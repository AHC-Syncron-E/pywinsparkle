# Building pywinsparkle Wheels

This document outlines the process for building the 32-bit and 64-bit Python wheels for `pywinsparkle` and explains the recent changes to support EdDSA signatures.

## 1. 🚨 Important: Update WinSparkle.dll

Before building, you **must** update the `WinSparkle.dll` files in this repository. The `setup.py` script packages the DLLs it finds in the `pywinsparkle/libs/` directory.

The recent changes to support EdDSA require **WinSparkle version 0.9.0 or newer**.

1.  Compile the WinSparkle C++ project for both `x86` (32-bit) and `x64` (64-bit) platforms.
2.  Copy your new `WinSparkle.dll` (32-bit) to `pywinsparkle/libs/x86/`.
3.  Copy your new `WinSparkle.dll` (64-bit) to `pywinsparkle/libs/x64/`.

The build will fail or the resulting wheel will not work if you try to call the new EdDSA functions using the old DLLs.

## 2. Prerequisites

* Python 3.x
* Required Python packages: `pip install wheel setuptools`
* A bash-compatible shell (e.g., Git Bash on Windows) to use the build script.

## 3. How to Build the Wheels

The build process generates platform-specific wheels that bundle the correct `WinSparkle.dll` for 32-bit (`win32`) and 64-bit (`win_amd64`) Python installations.

### Using the Build Script (Recommended)

The included `build_wheels.sh` script automates cleaning and building both wheels.

1.  Open a bash-compatible shell (like Git Bash).
2.  Navigate to the `BuildScripts` directory.
3.  Run the script:

```bash
./build_wheels.sh
````

This will create a `dist/` directory in the project root containing the two `.whl` files.

### Building Manually

You can also run the commands from the project root (where `setup.py` is located) manually.

1.  **Clean up old builds** (Optional but recommended):
    ```bash
    rm -rf build dist pywinsparkle.egg-info
    ```
2.  **Build the 64-bit wheel:**
    ```bash
    python setup.py bdist_wheel --plat-name=win_amd64
    ```
3.  **Build the 32-bit wheel:**
    ```bash
    python setup.py bdist_wheel --plat-name=win32
    ```

-----

## 4\. 🔒 Update for EdDSA Signature Support

This version of `pywinsparkle` has been updated to support the modern EdDSA (Ed25519) signature verification included in WinSparkle 0.9.0 and newer.

### Why This Change?

The underlying `WinSparkle` C++ library deprecated the older, less secure **DSA signatures**. It now strongly encourages using **EdDSA signatures** for verifying update files. This change keeps `pywinsparkle` up-to-date with modern security practices.

### What Was Added?

A new function, `win_sparkle_set_eddsa_public_key`, has been added to `pywinsparkle.py`.

  * **Old method (DSA):** `pywinsparkle.win_sparkle_set_dsa_pub_pem(pub_key_pem)`
  * **New method (EdDSA):** `pywinsparkle.win_sparkle_set_eddsa_public_key(pub_key_base64)`

The new function is a `ctypes` wrapper for the C++ `win_sparkle_set_eddsa_public_key()` function. It accepts a **Base64-encoded** string of your 32-byte EdDSA public key.

### How to Use the New Function

When initializing `pywinsparkle`, call the new function instead of the old one:

```python
import pywinsparkle
import base64

# Your 32-byte EdDSA public key
# (This is just an example, use your actual key)
my_public_key_bytes = b'MY_32_BYTE_PUBLIC_KEY_GOES_HERE'

# The key must be passed to WinSparkle as a Base64 string
my_public_key_base64 = base64.b64encode(my_public_key_bytes).decode('ascii')

# Set the EdDSA key
pywinsparkle.win_sparkle_set_eddsa_public_key(my_public_key_base64)

# ... continue with init
pywinsparkle.win_sparkle_init()
```

The original `win_sparkle_set_dsa_pub_pem()` function is still available for backward compatibility, but it is **strongly recommended** to migrate to EdDSA for all new and existing applications.
