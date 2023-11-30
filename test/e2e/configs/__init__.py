import logging

from os import path
from scripts.utils.system_path import SystemPath
from . import testpath, timeouts, testrail, squish, system

_logger = logging.getLogger(__name__)

try:
    from ._local import *
except ImportError:
    exit(
        'Config file: "_local.py" not found in "./configs".\n'
        'Please use template "_.local.default.py" to create file or execute command: \n'
        rf'cp {testpath.ROOT}/configs/_local.default.py {testpath.ROOT}/configs/_local.py'
    )

if AUT_PATH is None:
    exit('Please add "AUT_PATH" in ./configs/_local.py')
if system.IS_WIN and 'bin' not in AUT_PATH:
    exit('Please use launcher from "bin" folder in "AUT_PATH"')
AUT_PATH = SystemPath(AUT_PATH)

# Save application logs
AUT_DIR = path.dirname(AUT_PATH)
PYTEST_LOG = path.join(AUT_DIR, 'pytest.log')
AUT_LOGS_STDOUT = path.join(AUT_DIR, 'aut_stdout.log')
AUT_LOGS_STDERR = path.join(AUT_DIR, 'aut_stderr.log')
SERVER_LOGS_STDOUT = path.join(AUT_DIR, 'server_stdout.log')
SERVER_LOGS_STDERR = path.join(AUT_DIR, 'server_stderr.log')
