# -*- coding: utf-8 -*-

import re
import string
import random


def get_translated_value(context, value):
    context_var = re.findall(r'\[CONTEXT:([^\]]*)\]', value)
    if context_var:
        return get_translated_value(context, value.replace(f'[CONTEXT:{context_var[0]}]', getattr(context, context_var[0])))
    elif '[RANDOM]' in value:
        random_word = ''.join([random.choice(string.digits + string.ascii_lowercase) for i in range(10)])
        return get_translated_value(context, value.replace('[RANDOM]', random_word))
    elif '[RANDOM_INT]' in value:
        random_int = str(random.randint(1, 10000000000))
        return get_translated_value(context, value.replace('[RANDOM_INT]', random_int))
    return value
