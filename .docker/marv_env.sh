set -e
if [ -z "$CENV" ]; then
    export CENV=1
    source "/opt/ros/$ROS_DISTRO/setup.bash"
    test -e $MARV_VENV/bin/activate && source $MARV_VENV/bin/activate
fi
set +e
