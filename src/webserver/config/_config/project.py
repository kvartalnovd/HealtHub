# -*- coding: utf-8 -*-
from strictyaml import Map, Seq, Str, Int, Bool, load, YAMLValidationError, Optional, MapPattern
import os

from strictyaml.exceptions import YAMLSerializationError


class YmlConfig(object):
    def __init__(self, yaml_raw_data, cfg_schema):
        self.yaml = self.load(yaml_raw_data, cfg_schema).data

    def load(self, yaml_raw_data, cfg_schema):
        try:
            return load(yaml_raw_data, schema=cfg_schema)
        except YAMLValidationError as exc:
            raise exc

    def __iter__(self):
        return iter(self.yaml.items())

    def items(self):
        return self.yaml.items()

    def __getitem__(self, item):
        return self.yaml.get(item)

    def get(self, item):
        return self.yaml.get(item, default=None)


class OptionalMapPattern(MapPattern):
    def _should_be_mapping(self, data):
        if not isinstance(data, dict):
            raise YAMLSerializationError("Expected a dict, found '{}'".format(data))


schema = Map({
    "common": ""
})

CONFIG_ENV_NAME = 'mrc_config'.upper()

if CONFIG_ENV_NAME in os.environ:
    CFG_FILE = os.environ.get(CONFIG_ENV_NAME)
else:
    CFG_FILE = '/etc/my-ru-center/config.yml'

with open(CFG_FILE, 'r') as cfg:
    config_raw = cfg.read()

config = YmlConfig(config_raw, schema)
