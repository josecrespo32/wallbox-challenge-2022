from box import Box


def get_value_from_json_path(data, path):
    """
    Gets a value from a dict using dot notation:

    movie_box = Box({
    "Robin Hood: Men in Tights": {
        "imdb_stars": 6.7,
        "length": 104,
        "stars": [ {"name": "Cary Elwes", "imdb": "nm0000144", "role": "Robin Hood"},
                   {"name": "Richard Lewis", "imdb": "nm0507659", "role": "Prince John"} ]
    }
    })

    movie_box.Robin_Hood_Men_in_Tights.imdb_stars
    # 6.7

    :param data: dict from which value will be taken
    :param path: path to value
    :return: value in path
    """
    data_box = Box(data)

    final_path = 'data_box'

    for key in path.split('.'):
        if key.isdigit():
            final_path += f'[{key}]'
        else:
            final_path += f'.{key}'

    return eval(final_path)

def get_value_from_context(context, key):
    """
    Return the value of the key stored in context
    :param context: behave test context
    :param path:
    :return: value from context
    """

    key_in_context = key.split(':')[1]
    return context.values[key_in_context]