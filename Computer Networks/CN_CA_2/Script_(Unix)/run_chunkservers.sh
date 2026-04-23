#!/usr/bin/env bash

STORAGE="/Users/majidsadeghinejad/Desktop/UT/SEM6/CN/CA/CN_CA_2/Storage"

for i in $(seq 0 14); do
  ./ChunkServer -i "$i" -d "$STORAGE" &
done

echo "Launched 15 chunk servers (0-14) all writing into $STORAGE"