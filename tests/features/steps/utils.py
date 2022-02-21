import copy
import datetime
import logging
import re

LOG_FILENAME = f"logs/test_challenge.log"

CONF_KEYWORD = 'CONF'
CONF_REGEXP = f'{CONF_KEYWORD}\:([a-zA-Z\.\_]+)'

CONTEXT_KEYWORD = 'CONTEXT'
CONTEXT_REGEXP = f'{CONTEXT_KEYWORD}\:([a-z]+)'


def set_logging():
    logging.basicConfig(
        handlers=[logging.FileHandler(filename=LOG_FILENAME,
                                      encoding='utf-8',
                                      mode='a+')],
        format='%(asctime)-24s %(levelname)-8s %(message)s',
        level=logging.DEBUG)

    logging.getLogger('urllib3.connectionpool').setLevel(logging.WARNING)


def get_json_entry_from_path(json_data, path):
    temp = copy.copy(json_data)
    for value in path.split('.'):
        if value.isdigit():
            temp = temp[int(value)]
        else:
            temp = temp.get(value)

    return str(temp)


def parse_string(context, text):
    temp = copy.copy(text)
    for conf in re.findall(CONF_REGEXP, text):
        temp = temp.replace(f'{CONF_KEYWORD}:{conf}',
                            get_json_entry_from_path(context.tests_config, conf))
    for ctx in re.findall(CONTEXT_REGEXP, text):
        temp = temp.replace(f'{CONTEXT_KEYWORD}:{ctx}',
                            getattr(context, ctx))

    return temp
