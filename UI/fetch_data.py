import os

import pandas as pd
import requests
import streamlit as st

DEFAULT_FASTAPI_URL = "https://mist353-api-wright.azurewebsites.net"
REQUEST_TIMEOUT_SECONDS = 60


def _get_fastapi_url():
    return (
        os.getenv("FASTAPI_URL")
        or st.secrets.get("FASTAPI_URL", DEFAULT_FASTAPI_URL)
    ).rstrip("/")


def fetch_data(endpoint: str, input_params: dict | None = None):
    try:
        response = requests.get(
            f"{_get_fastapi_url()}/{endpoint.lstrip('/')}",
            params=input_params or {},
            timeout=REQUEST_TIMEOUT_SECONDS,
        )
    except requests.RequestException as exc:
        st.error(f"Unable to reach the API: {exc}")
        return None

    if response.status_code == 200:
        payload = response.json()
        if isinstance(payload, list):
            return pd.DataFrame(payload)
        rows = payload.get("data", [])
        return pd.DataFrame(rows)

    detail = ""
    try:
        detail = response.json().get("detail", "")
    except ValueError:
        detail = response.text

    st.error(f"Error fetching data ({response.status_code}): {detail}")
    return None
