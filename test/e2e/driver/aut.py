import allure
import logging
import cv2
import numpy as np
import squish
from PIL import ImageGrab

import configs
import driver
from os import path
from datetime import datetime
from configs.system import IS_LIN
from driver import context
from driver.server import SquishServer
from gui.objects_map import statusDesktop_mainWindow
from scripts.utils import system_path, local_system
from scripts.utils.system_path import SystemPath

LOG = logging.getLogger(__name__)


class AUT:
    def __init__(
            self,
            app_path: system_path.SystemPath = configs.AUT_PATH,
            user_data: SystemPath = None
    ):
        super(AUT, self).__init__()
        self.path = app_path
        self.ctx = None
        self.pid = None
        self.port = None
        self.aut_id = f'AUT_{datetime.now():%H%M%S}'
        self.app_data = configs.testpath.STATUS_DATA / f'app_{datetime.now():%H%M%S_%f}'
        if user_data is not None:
            user_data.copy_to(self.app_data / 'data')
        self.options = ''
        driver.testSettings.setWrappersForApplication(self.aut_id, ['Qt'])

    def __str__(self):
        return type(self).__qualname__

    def __enter__(self):
        return self.launch()

    def __exit__(self, exc_type, exc_value, traceback):
        if exc_type:
            try:
                self.attach()
                driver.waitForObjectExists(statusDesktop_mainWindow).setVisible(True)
                configs.testpath.TEST.mkdir(parents=True, exist_ok=True)
                screenshot = configs.testpath.TEST / f'{self.aut_id}.png'

                rect = driver.object.globalBounds(driver.waitForObject(statusDesktop_mainWindow))
                img = ImageGrab.grab(
                    bbox=(rect.x, rect.y, rect.x + rect.width, rect.y + rect.height),
                    xdisplay=configs.system.DISPLAY if IS_LIN else None)
                view = cv2.cvtColor(np.array(img), cv2.COLOR_BGR2RGB)
                cv2.imwrite(str(screenshot), view)

                allure.attach(
                    name=f'Screenshot on fail: {self.aut_id}',
                    body=screenshot.read_bytes(),
                    attachment_type=allure.attachment_type.PNG)
            except Exception as err:
                LOG.info(err)

        self.stop()

    @allure.step('Attach Squish to Test Application')
    def attach(self, timeout_sec: int = configs.timeouts.PROCESS_TIMEOUT_SEC):
        if self.ctx is None:
            self.ctx = context.attach(self.aut_id, timeout_sec)
        squish.setApplicationContext(self.ctx)

    def _detach_context(self):
        if self.ctx is None:
            return
        squish.currentApplicationContext().detach()
        self.ctx = None

    def _kill_process(self):
        if self.pid is None:
            LOG.warning('No PID availale for AUT.')
            return
        local_system.kill_process_with_retries(self.pid)
        self.pid = None

    @allure.step('Close application')
    def stop(self):
        LOG.info('Stoping AUT: %s', self.path)
        self._detach_context()
        self._kill_process()

    @allure.step("Start application")
    def launch(self) -> 'AUT':
        LOG.info('Launching AUT: %s', self.path)
        self.port = local_system.find_free_port(configs.squish.AUT_PORT, 100)
        SquishServer().add_attachable_aut(self.aut_id, self.port)
        command = [
            str(configs.testpath.SQUISH_DIR / 'bin/startaut'),
            f'--port={self.port}',
            str(self.path),
            f'-d={self.app_data}',
            f'--LOG_LEVEL={configs.testpath.LOG_LEVEL}',
        ]
        try:
            self.pid = local_system.execute_with_log_files(command)
            LOG.debug('Launched AUT under PID: %d', self.pid)
            self.attach()
            assert squish.waitFor(lambda: self.ctx.isRunning, configs.timeouts.PROCESS_TIMEOUT_SEC)
            return self
        except Exception as err:
            LOG.error('Failed to start AUT: %s', err)
            self.stop()
            raise err

    @allure.step('Restart application')
    def restart(self):
        self.stop()
        self.launch()
