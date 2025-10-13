'''
- Author: ASM CHAFIULLAH BHUIYAN
- File: InitiateConnectionSSH.py
- Date: 2025-10-13
- Description: Class-based SSH client to connect to a remote OpenROADM emulator,
  write outputs, and disconnect cleanly.
'''

import os
import sys
from typing import Optional

from ncclient import manager
from dotenv import load_dotenv
from loguru import logger


class InitiateConnectionSSH:
    """Manage a NETCONF-over-SSH connection and file output.

    Methods:
    - connect(): establish the NETCONF session
    - disconnect(): close the session if open
    - write_to_file(filename, content): write content to outputs directory
    """

    def __init__(
        self,
        host: Optional[str] = None,
        port: Optional[int] = None,
        username: Optional[str] = None,
        password: Optional[str] = None,
        timeout: Optional[int] = None,
        outputs_dir: Optional[str] = None,
    ) -> None:
        # Load environment variables (no-op if already loaded)
        load_dotenv()

        self.host = host or os.getenv("OR_HOST")
        self.port = int(port or os.getenv("OR_PORT", "830"))
        self.username = username or os.getenv("OR_USER")
        self.password = password or os.getenv("OR_PASS")
        self.timeout = int(timeout or os.getenv("OR_TIMEOUT", "30"))

        # Default outputs to a folder next to this script for consistency
        default_outputs = os.path.join(os.path.dirname(__file__), "outputs")
        self.outputs_dir = outputs_dir or default_outputs

        self._session: Optional[manager.Manager] = None

    # --- Connection management ---
    def connect(self) -> manager.Manager:
        """Establish a NETCONF-over-SSH connection and return the session."""
        if not self.host or not self.username or not self.password:
            raise ValueError(
                "Missing connection parameters: ensure host, username, and password are provided or set in env vars."
            )

        if self._session and getattr(self._session, "connected", False):
            logger.info("Session already connected; reusing existing session.")
            return self._session

        logger.info(
            f"Initiating SSH connection to {self.host}:{self.port} as {self.username} ...")
        self._session = manager.connect(
            host=self.host,
            port=self.port,
            username=self.username,
            password=self.password,
            hostkey_verify=False,
            allow_agent=False,
            look_for_keys=False,
            timeout=self.timeout,
        )

        if not self._session.connected:
            raise ConnectionError("Failed to establish SSH connection.")

        logger.success("SSH connection established successfully!")
        return self._session

    def disconnect(self) -> None:
        """Close the session if it is open."""
        if self._session is None:
            logger.info("No active session to disconnect.")
            return
        try:
            logger.info(f"Aborting connection to {self.host}:{self.port} ...")
            self._session.close_session()
            logger.success("Connection closed.")
        finally:
            self._session = None

    # --- File utilities ---
    def write_to_file(self, filename: str, content: str, mode: str = "w") -> str:
        """Write content to a file inside the outputs directory and return the path."""
        os.makedirs(self.outputs_dir, exist_ok=True)
        path = filename
        if not os.path.isabs(filename):
            path = os.path.join(self.outputs_dir, filename)

        with open(path, mode) as f:
            f.write(content)

        logger.success(f"Saved to {path}")
        return path

    # --- Task-specific helpers ---
    def write_capabilities_to_file(self, filename: str = "capabilities.txt") -> str:
        """Collect server capabilities from the active session and write them to file."""
        if not (self._session and self._session.connected):
            raise RuntimeError(
                "No active session. Call connect() before writing capabilities.")
        capabilities = "\n".join(sorted(self._session.server_capabilities))
        return self.write_to_file(filename, capabilities)


def main() -> None:
    client = InitiateConnectionSSH()
    try:
        client.connect()
        client.write_capabilities_to_file()
    finally:
        client.disconnect()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        logger.error(f"Error: {e}")
        sys.exit(1)
