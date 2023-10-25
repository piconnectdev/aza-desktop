import allure
import pyperclip
import pytest
from allure_commons._allure import step

import configs.testpath
import constants
import driver
from constants import UserAccount
from constants.syncing import SyncingSettings
from gui.components.onboarding.before_started_popup import BeforeStartedPopUp
from gui.components.onboarding.beta_consent_popup import BetaConsentPopup
from gui.components.splash_screen import SplashScreen
from gui.main_window import MainWindow
from gui.screens.onboarding import AllowNotificationsView, WelcomeToStatusView, SyncResultView, \
    SyncCodeView, SyncDeviceFoundView



@pytest.fixture
def sync_screen(main_window) -> SyncCodeView:
    with step('Open Syncing view'):
        if configs.system.IS_MAC:
            AllowNotificationsView().wait_until_appears().allow()
        BeforeStartedPopUp().get_started()
        wellcome_screen = WelcomeToStatusView().wait_until_appears()
        return wellcome_screen.sync_existing_user().open_sync_code_view()


@allure.testcase('https://ethstatus.testrail.net/index.php?/cases/view/703592', 'Sync device during onboarding')
@pytest.mark.case(703592)
@pytest.mark.parametrize('user_data', [configs.testpath.TEST_USER_DATA / 'user_account_one'])
@pytest.mark.skip(reason="https://github.com/status-im/status-desktop/issues/12550")
def test_sync_device_during_onboarding(multiple_instance, user_data):
    user: UserAccount = constants.user_account_one
    main_window = MainWindow()

    with (multiple_instance() as aut_one, multiple_instance() as aut_two):
        with step('Get syncing code in first instance'):
            aut_one.attach()
            main_window.prepare()
            main_window.authorize_user(user)
            sync_settings_view = main_window.left_panel.open_settings().left_panel.open_syncing_settings()
            sync_settings_view.is_instructions_header_present()
            sync_settings_view.is_instructions_subtitle_present()
            if configs.DEV_BUILD:
                sync_settings_view.is_backup_button_present()
            setup_syncing = main_window.left_panel.open_settings().left_panel.open_syncing_settings().set_up_syncing(
                user.password)
            sync_code = setup_syncing.syncing_code
            setup_syncing.done()
            main_window.hide()

        with step('Verify syncing code is correct'):
            sync_code_fields = sync_code.split(':')
            assert sync_code_fields[0] == 'cs3'
            assert len(sync_code_fields) == 5

        with step('Open sync code form in second instance'):
            aut_two.attach()
            main_window.prepare()
            if configs.system.IS_MAC:
                AllowNotificationsView().wait_until_appears().allow()
            BeforeStartedPopUp().get_started()
            wellcome_screen = WelcomeToStatusView().wait_until_appears()
            sync_view = wellcome_screen.sync_existing_user().open_sync_code_view()

        with step('Paste sync code on second instance and wait until device is synced'):
            sync_start = sync_view.open_enter_sync_code_form()
            sync_start.paste_sync_code()
            sync_device_found = SyncDeviceFoundView()
            assert driver.waitFor(lambda: 'Device found!' in sync_device_found.device_found_notifications)
            sync_result = SyncResultView().wait_until_appears()
            assert driver.waitFor(lambda: 'Device synced!' in sync_result.device_synced_notifications)
            assert user.name in sync_device_found.device_found_notifications

        with step('Sign in to synced account'):
            sync_result.sign_in()
            SplashScreen().wait_until_appears().wait_until_hidden()
            if not configs.DEV_BUILD:
                if driver.waitFor(lambda: BetaConsentPopup().exists, configs.timeouts.UI_LOAD_TIMEOUT_MSEC):
                    BetaConsentPopup().confirm()

        with step('Verify user details are the same with user in first instance'):
            user_canvas = main_window.left_panel.open_user_canvas()
            user_canvas_name = user_canvas.user_name
            assert user_canvas_name == user.name
            # TODO: temp removing tesseract usage because it is not stable
            # assert driver.waitFor(
            #    lambda: user_canvas.is_user_image_contains(user.name[:2]),
            #    configs.timeouts.UI_LOAD_TIMEOUT_MSEC
            # )


@allure.testcase('https://ethstatus.testrail.net/index.php?/cases/view/703631', 'Wrong sync code')
@pytest.mark.case(703631)
@pytest.mark.parametrize('wrong_sync_code', [
    pytest.param('9rhfjgfkgfj890tjfgtjfgshjef900')
])
def test_wrong_sync_code(sync_screen, wrong_sync_code):
    with step('Open sync code form'):
        sync_view = sync_screen.open_enter_sync_code_form()

    with step('Paste wrong sync code on second instance and check that error message appears'):
        pyperclip.copy(wrong_sync_code)
        sync_view.paste_sync_code()
        assert SyncingSettings.SYNC_CODE_IS_WRONG_TEXT.value == sync_view.sync_code_error_message, f'Wrong sync code message did not appear'
