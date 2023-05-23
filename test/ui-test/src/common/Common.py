import configs
import drivers.SquishDriver as driver
import drivers.SquishDriverVerification as verification
import drivers.SDKeyboardCommands as keyCommands


def start_application(app_data_dir=configs.path.STATUS_APP_DATA, clear_user_data: bool = True):
    driver.start_application(app_data_dir=app_data_dir, clear_user_data=clear_user_data)


def click_on_an_object(objName: str):
    driver.click_obj_by_name(objName)


def input_text(text: str, objName: str):
    driver.type_text(objName, text)


def object_not_enabled(objName: str):
    verification.verify_object_enabled(objName, 500, False)


def str_to_bool(string: str):
    return string.lower() in ["yes", "true", "1", "y", "enabled"]


def clear_input_text(objName: str):
    keyCommands.press_select_all(objName)
    keyCommands.press_backspace(objName)
