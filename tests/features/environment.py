import logging

import yaml
from behave import *
from steps.utils import set_logging

TESTS_CONFIGURATION_FILE = 'configuration.yaml'


def before_all(context):

    set_logging()
    logger = logging.getLogger(__name__)

    try:
        with open(TESTS_CONFIGURATION_FILE, 'r') as f:
            context.tests_config = yaml.safe_load(f.read())
    except Exception as err:
        raise(f'ERROR: loading tests configuration file [{TESTS_CONFIGURATION_FILE}]:\n{err}\n')

    logger.debug(f'Loaded YAML configuration from [{TESTS_CONFIGURATION_FILE}] --> {context.tests_config}')
