# -*- coding: UTF-8 -*-
import shutil
from steps.common_steps.common_environment import docker_setup


def before_all(context):
    docker_setup(context)
    context.build_or_pull_image(skip_pull=True, skip_build=True)


def after_scenario(context, scenario):
    if 'KEEP_CONTAINER_AFTER_TEST' in context.config.userdata:
        return
    context.remove_container()


def after_all(context):
    if hasattr(context, 'temp_dir'):
        shutil.rmtree(context.temp_dir)  # FIXME catch exception
