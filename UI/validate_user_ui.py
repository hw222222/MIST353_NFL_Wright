import streamlit as st

from fetch_data import fetch_data


def validate_user_ui():
    st.header("Validate User")

    email = st.text_input("Enter Email")
    password = st.text_input("Enter Password", type="password")

    if st.button("Validate User", key="validate_user"):
        if not email.strip():
            st.warning("Please enter an email.")
            return

        if not password.strip():
            st.warning("Please enter a password.")
            return

        df = fetch_data(
            "validate-user",
            {
                "email": email.strip(),
                "password": password.strip(),
            },
        )

        if df is None:
            return

        if not df.empty:
            st.subheader(f"Validated user for {email}:")
            st.dataframe(df, use_container_width=True, hide_index=True)
            st.session_state.app_user_id = df["AppUserID"].iloc[0]
            st.session_state.app_user_fullname = df["Fullname"].iloc[0]
        else:
            st.info("No matching user was found for the provided credentials.")
