#!/bin/bash

fwd() {
  sudo -E kubefwd svc --all-namespaces
}
