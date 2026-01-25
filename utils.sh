#!/bin/bash


set_flag_value() {
    local flag="$1"
    local value="$2"
    sed -i "s|^$flag=.*|$flag=$value|" "$CONFIG"
}
