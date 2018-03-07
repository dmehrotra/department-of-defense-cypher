#!/bin/bash
psql dod_contracts < export.sql
python clean_contracts.py
