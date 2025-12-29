##!/usr/bin/env python
# SPDX-FileCopyrightText: 2025 Reo Yamaguchi
# SPDX-License-Identifier: BSD-3-Clause:

import rclpy
from rclpy.node import Node
from std_msgs.msg import Float32

class CpuListenerNode(Node):
    def __init__(self):
        super().__init__('cpu_listener_node')
        # 'cpu_usage'取得
        self.subscription = self.create_subscription(
            Float32,
            'cpu_usage',
            self.listener_callback,
            10)
        self.get_logger().info('CPU Listener Node has started.')

    def listener_callback(self, msg):
        usage = msg.data
        if usage > 80.0:
            self.get_logger().warn(f'High CPU Usage Detected: {usage}%!')
        else:
            self.get_logger().info(f'Received CPU Usage: {usage}%')

def main(args=None):
    rclpy.init(args=args)
    node = CpuListenerNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        # エラー回避
        if rclpy.ok():
            node.destroy_node()
            rclpy.shutdown()

if __name__ == '__main__':
    main()