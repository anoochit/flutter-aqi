#!/bin/bash
flutter build bundle -v
scp -r build/flutter_assets pi@raspberrypi.local:~/
