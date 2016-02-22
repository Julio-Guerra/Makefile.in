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

##
# m.in/toolchain/docker/recipe/build(dockerfile, tag, flags?)
# Remove the existing tag if it exists and create a docker image with
# given Dockerfile and flags. The build context is the project's root
# directory. To be able to depend on this target, a dummy file is
# created in the current build directory, under the same directory
# tree as the Dockerfile.
#
define m.in/toolchain/docker/recipe/build =
test -f $@ && ( $(m.in/toolchain/docker/bin/docker) rmi -f $(m.in/argv/2) || true ) # do not fail
$(m.in/toolchain/docker/bin/docker) build \
  -t $(m.in/argv/2)                       \
  -f $(m.in/argv/1)                       \
  $(strip $3)                             \
  $(m.in/root)
$(if $(m.in/out_of_source), $(call m.in/mkdir, $(@D)))
touch $@
endef

##
# m.in/toolchain/docker/recipe/run(image, dockerflags?, command?)
# Run a docker image with given optional dockerflags and command.
#
define m.in/toolchain/docker/recipe/run =
$(m.in/toolchain/docker/bin/docker) run $(strip $2) $(m.in/argv/1) $(strip $3)
endef

## \}

##
# Toolchain Makers
# \{
#

##
# m.in/toolchain/docker/make_build(dockerfile, tag, flags?)
#
# Implementation:
# This is an empty target because docker does not create something make can
# track. Use a dummy file to avoid unwanted builds and allow make to correctly
# track other targets depending on this one.
#
define m.in/toolchain/docker/make_build =
$(call make_explicit, $(dir $(m.in/argv/1))$(m.in/argv/2),
                      docker,
                      build,
                      $(m.in/argv/1),
                      $(m.in/argv/2),
                      $3)
$(call dependencies_abs, $(m.in/argv/1) $$$$(m.in/global_dependencies))
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
$(shell [ "$$($(m.in/toolchain/docker/bin/docker) inspect -f '{{.State.Running}}' $(m.in/argv/1) 2>/dev/null)" \
  = true ] && echo t)
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
# Cf. `m.in/proxy/recipe()` for more details.
#
define m.in/toolchain/docker/dockerize/target =
$(call m.in/proxy/target, $(m.in/argv/1), $(or $(strip $2),docker\:))
endef
