# Compatibility Matrix

| Module Version / Kubernetes Version | 1.14.X             | 1.15.X             | 1.16.X             | 1.17.X             | 1.18.X             | 1.19.X             | 1.20.X             | 1.21.X             | 1.22.X             | 1.23.X    |
|-------------------------------------|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|:------------------:|-----------|
| v1.3.0                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |           |
| v1.3.1                              | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |                    |                    |           |
| v1.4.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: |                    |                    |                    |                    |           |
| v1.5.0                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |                    |                    |                    |           |
| v1.5.1                              |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |                    |                    |                    |           |
| v1.6.0                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |                    |                    |           |
| v1.6.1                              |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |                    |                    |           |
| v1.7.0                              |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |                    |           |
| v1.8.0                              |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning:          |           |
| v1.9.0                              |                    |                    |                    |                    |                    |                    | :x:                | :x:                | :x:                | :x:       |
| v1.9.1                              |                    |                    |                    |                    |                    |                    | :x:                | :x:                | :x:                | :x:       |
| v1.9.2                              |                    |                    |                    |                    |                    |                    | :warning:          | :warning:          | :warning:          | :warning: |
| v1.9.3                              |                    |                    |                    |                    |                    |                    | :white_check_mark: | :white_check_mark: | :white_check_mark: | :warning: |

:white_check_mark: Compatible

:warning: Has issues

:x: Incompatible

## Warning

- :x:: module version: v1.9.0 has a known bug breaking upgrades. Please do not use.
- :x:: module version: v1.9.1 has a known bug breaking upgrades. Please do not use.
