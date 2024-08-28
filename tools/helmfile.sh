#!/bin/bash

syncapp() {
  helmfile destroy -lapp="$1" --skip-deps --debug
  helmfile sync -lapp="$1" --skip-deps --debug
}
