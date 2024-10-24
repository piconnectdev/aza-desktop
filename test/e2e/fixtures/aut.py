import allure
import os

import pytest
import logging
import constants
from configs import get_platform
from constants.user import *
from driver.aut import AUT
from gui.main_window import MainWindow
from scripts.utils import system_path
from scripts.utils.local_system import get_pid_by_process_name, kill_process
from scripts.utils.system_path import SystemPath

LOG = logging.getLogger(__name__)


@pytest.fixture
def options(request):
    if hasattr(request, 'param'):
        return request.param
    return ''


@pytest.fixture
def keycard_controller(request):
    if 'settings_keycard' in str(getattr(request, 'fspath')):
        os.environ['STATUS_RUNTIME_USE_MOCKED_KEYCARD'] = 'True'


@pytest.fixture
def application_logs():
    yield
    if configs.testpath.STATUS_DATA.exists():
        for app_data in configs.testpath.STATUS_DATA.iterdir():
            for log_dir in ['logs', 'data']:
                log_path = app_data / log_dir
                for log in log_path.glob('*.log'):
                    allure.attach.file(log, name=str(log.name), attachment_type=allure.attachment_type.TEXT)
                    try:
                        log.unlink()  # FIXME: it does not work on Windows, permission error
                    except PermissionError:
                        print(f"Permission error: {log} could not be deleted.")


@pytest.fixture
def user_data(request) -> system_path.SystemPath:
    if hasattr(request, 'param'):
        fp = request.param
        assert fp.is_dir()
        return fp


@pytest.fixture
def aut(user_data) -> AUT:
    if not configs.AUT_PATH.exists():
        pytest.exit(f"Application not found: {configs.AUT_PATH}")
    _aut = AUT(user_data=user_data)
    yield _aut


@pytest.fixture()
def multiple_instances(user_data):
    def _aut(user_data: SystemPath = None) -> AUT:
        if not configs.AUT_PATH.exists():
            pytest.exit(f"Application not found: {configs.AUT_PATH}")
        return AUT(user_data=user_data)

    yield _aut


@pytest.fixture
def main_window(aut: AUT, user_data):
    aut.launch()
    LOG.debug('Waiting for main window...')
    yield MainWindow().wait_until_appears().prepare()
    aut.stop()


@pytest.fixture
def user_account(request) -> UserAccount:
    if hasattr(request, 'param'):
        user_account = request.param
        assert isinstance(user_account, UserAccount)
    else:
        user_account = constants.user.RandomUser()
    yield user_account


@pytest.fixture
def main_screen(user_account: UserAccount, main_window: MainWindow) -> MainWindow:
    main_window.authorize_user(user_account)
    return main_window

