##!/usr/bin/env python
# SPDX-FileCopyrightText: 2025 Reo Yamaguchi
# SPDX-License-Identifier: BSD-3-Clause:


# log消去
dir=~/.ros/log
[ -d "$dir" ] && rm -rf "$dir"

# 環境確認
source /opt/ros/jazzy/setup.bash
source ./install/setup.bash

# Launchファイル
ros2 launch my_cpu_monitor monitor.launch.py > /tmp/ros_test.log 2>&1 &
pid=$!

# 起動を確認
sleep 10

# トピック確認
echo "Testing: Topic list check..."
ros2 topic list | grep '/cpu_usage' || { echo "Topic /cpu_usage not found"; kill $pid; exit 1; }

# 実際に動いているか
echo "Testing: Topic data flow check..."
timeout 10s ros2 topic echo --once /cpu_usage || { echo "No data received on /cpu_usage"; kill $pid; exit 1; }

# 数値範囲の異常検知
usage=$(ros2 topic echo --once /cpu_usage | grep 'data:' | awk '{print $2}')
echo "Received CPU Usage: $usage"
res=$(echo "$usage >= 0.0 && $usage <= 100.0" | bc -l)
if [ "$res" -eq 1 ]; then
    echo "Data range is valid."
else
    echo "Invalid data range: $usage"; kill $pid; exit 1
fi

# 終了
kill $pid
echo "All integration tests passed!"
exit 0