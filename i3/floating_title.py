#!/usr/bin/env python3

import i3ipc

i3 = i3ipc.Connection()

def on_window_open(i3, e):
    ws = i3.get_tree().find_focused().workspace()
    e.container.command('border normal')

i3.on('window::floating', on_window_open)

i3.main()
