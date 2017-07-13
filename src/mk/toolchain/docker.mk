##
# Docker Toolchain Definition
#

##
# m.in/toolchain/docker/bin/docker
# Docker Client Program
#
m.in/toolchain/docker/bin/docker := docker

##
# Toolchain Recipes
# \{
#

m.in/toolchain/docker/recipe/*/clean = $(m.in/toolchain/gnu/recipe/*/clean)
m.in/toolchain/docker/recipe/*/distclean = $(m.in/toolchain/gnu/recipe/*/distclean)

##
# m.in/toolchain/docker/recipe/build(dockerfile, tag, context, flags?)
# Remove the existing tag if it exists and create a docker image with
# given Dockerfile and flags. The build context is the dockerfile's
# directory. To be able to depend on this target, a dummy file is
# created in the current build directory, under the same directory
# tree as the Dockerfile.
#
define m.in/toolchain/docker/recipe/build =
if test -f $@; then \
  $(m.in/toolchain/docker/bin/docker) rmi --force  --no-prune $(m.in/argv/2); \
fi
$(m.in/toolchain/docker/bin/docker) build \
  -t $(m.in/argv/2)                       \
  -f $(m.in/argv/1)                       \
  $(strip $4)                             \
  $(m.in/argv/3)
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
$(call m.in/mkdir, $(@D))
touch $@
endef

##
# m.in/toolchain/docker/recipe/run(image, name, flags?, command?)
# Run a docker image with given optional flags and command.
#
define m.in/toolchain/docker/recipe/run =
if $(call m.in/toolchain/docker/recipe/is_container_running, $(m.in/argv/2)); then    \
  $(m.in/toolchain/docker/bin/docker) rm --force $(m.in/argv/2); \
fi
$(m.in/toolchain/docker/bin/docker) run --name $(m.in/argv/2) $(strip $3) $(m.in/argv/1) $(strip $4)
$(call m.in/mkdir, $(dir $(call m.in/toolchain/docker/run/tracker, $(m.in/argv/1))))
touch $(call m.in/toolchain/docker/run/tracker, $(m.in/argv/1))
endef

##
# m.in/toolchain/docker/recipe/is_container_running(container)
# Exit status is 0 (true) when given `container` state is running.
#
define m.in/toolchain/docker/recipe/is_container_running =
[ "$$($(m.in/toolchain/docker/bin/docker) inspect -f '{{.State.Running}}' $(m.in/argv/1) 2>/dev/null)" \
  = true ]
endef

##
# m.in/toolchain/docker/recipe/container_exists(container)
# Exit status is 0 (true) when given `container` exists.
#
define m.in/toolchain/docker/recipe/container_exists =
$(m.in/toolchain/docker/bin/docker) inspect $(m.in/argv/1) >&- 2>&-
endef

## \}

##
# Toolchain Makers
# \{
#

m.in/toolchain/docker/mkdir = $(m.in/toolchain/gnu/mkdir)

##
# m.in/toolchain/docker/make_build(dockerfile, tag, flags?)
#
# Implementation:
# Use a dummy file to avoid unwanted builds and allow make to correctly
# track other targets depending on this one.
#
define m.in/toolchain/docker/make_build =
$(call make_explicit, $(call m.in/toolchain/docker/build/tracker, $(m.in/argv/2)),
                      docker,
                      build,
                      $(m.in/argv/1),
                      $(m.in/argv/2),
                      $3)
$(call dependencies_abs, $(m.in/argv/1) $$$$(m.in/global_dependencies))
endef

##
# m.in/toolchain/docker/make_run(image, name, flags?, command?)
# Run a docker image.
#
define m.in/toolchain/docker/make_run =
$(call make_explicit, $(call m.in/toolchain/docker/run/tracker, $(m.in/argv/1)),
                      docker,
                      run,
                      $(m.in/argv/1),
                      $(m.in/argv/2),
                      $3,
                      $4)
$(call dependencies_abs, $$$$(m.in/global_dependencies))
endef

##
# m.in/toolchain/docker/run/tracker(image)
# Return a tracker filename to track the run of an image.
#
define m.in/toolchain/docker/run/tracker =
$(call m.in/toolchain/docker/tracker, run, $(m.in/argv/1))
endef

##
# m.in/toolchain/docker/build/tracker(tag)
# Return a tracker filename to track the build of a Dockerfile.
#
define m.in/toolchain/docker/build/tracker =
$(call m.in/toolchain/docker/tracker, build, $(m.in/argv/1))
endef

##
# m.in/toolchain/docker/tracker(name)
# Return a tracker filename to track the docker command.
#
define m.in/toolchain/docker/tracker =
$(call m.in/tracker, $(m.in/argv/1)/$(subst /,-,$(subst :,-,$(m.in/argv/2))))
endef

## \}

##
# m.in/toolchain/docker/is_make_in_docker()
# Return True (non-empty string) when make is inside a container.
#
define m.in/toolchain/docker/is_make_in_docker =
$(shell test -f /.dockerinit -o -f /.dockerenv && echo y)
endef

##
# m.in/toolchain/docker/is_container_running(container)
# Return True (non-empty string) when given `container` state is running.
#
define m.in/toolchain/docker/is_container_running =
$(shell $(m.in/toolchain/docker/recipe/is_container_running) && echo t)
endef

##
# m.in/toolchain/docker/container_exists(container)
# Return True (non-empty string) when given `container` exists.
#
define m.in/toolchain/docker/container_exists =
$(shell $(m.in/toolchain/docker/recipe/inspect) && echo t)
endef


##
# m.in/toolchain/docker/dockerize/recipe(command, recipe)
# Proxy a recipe through a proxy command's stdin. If the command is empty,
# the macro call is a no-op. This allows the user to implement its own logic:
# when does he need to proxy and when does he need no to?
# Usually, the proxying can stop once we are inside a docker container.
# But things like docker-in-docker may need deeper proxying :)
# Cf. `m.in/proxy/recipe()` for more details.
#
define m.in/toolchain/docker/dockerize/recipe =
$(call m.in/proxy/recipe, $1, $(m.in/argv/2))
endef

##
# m.in/toolchain/docker/dockerize/target(command, target-prefix?)
# Proxy make targets through a (supposedly) docker command.
# The resulting target prefix is `docker:` by default or `target-prefix`
# argument when provided.
# Cf. `m.in/proxy/target()` for more details.
#
define m.in/toolchain/docker/dockerize/target =
$(call m.in/proxy/target, $(m.in/argv/1), $(or $(strip $2),docker\:))
endef
