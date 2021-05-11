#!/usr/bin/env bash


xcodebuild \
        clean \
        test \
        -scheme "ChatApp" \
        -destination "platform=iOS Simulator,name=iPhone 12,OS=14.5"

echo "work done!"