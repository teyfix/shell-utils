#!/bin/bash

syncapp() {
  helmfile sync -lapp="$1" --skip-deps --debug
}
