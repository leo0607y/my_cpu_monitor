# CPU使用率監視パッケージ
[![test](https://github.com/leo0607y/mypkg0/actions/workflows/test.yml/badge.svg)](https://github.com/leo0607y/mypkg0/actions/workflows/test.yml)
本パッケージは、システムのCPU負荷をROS2ネットワーク上に配信する `monitor` ノードと、それを受信してターミナル上にゲージを表示する `listener` ノードで構成。

## テスト環境
- 実行環境: GitHub-hosted runner (ubuntu-22.04)
- コンテナイメージ: `ryuichiueda/ubuntu22.04-ros2:latest`
    - ROS 2 Version: Humble

## 各ノードの機能
### monitor
- システムのCPU使用率を取得し、ROS 2トピックとして配信
- プログラム名: `monitor_node.py`
- `psutil` ライブラリを使用してCPU使用率を取得
- パブリッシュ (Output): `/cpu_usage` ([std_msgs/msg/Float32]): 現在のCPU使用率 [%]

### listener
- 配信されたCPU使用率を受信し、視覚化し表示
- プログラム名: `listener_node.py`
- 受信した数値をもとに、50段階で（`#`）を用いたゲージ表示
- サブスクライブ (Input): `/cpu_usage` ([std_msgs/msg/Float32]): 受信したCPU使用率 [%]

## トピックの仕様説明
### `/cpu_usage`
- 型: `std_msgs/Float32`
- 単位: `%`
- 内容: システム全体のCPU使用率（0.0〜100.0）

## 使用方法
###　monitor
- 以下コマンドでCPUの使用率配信を独立して実行
```bash
$ ros2 run my_cpu_monitor monitor

[INFO] [cpu_monitor_node]: CPU Monitor Node has started.
[INFO] [cpu_monitor_node]: Publishing CPU Usage: 8.7%
[INFO] [cpu_monitor_node]: Publishing CPU Usage: 2.1%
[INFO] [cpu_monitor_node]: Publishing CPU Usage: 11.2%
```

