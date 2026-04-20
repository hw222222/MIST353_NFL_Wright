from typing import Optional

from fastapi import FastAPI, HTTPException, Query

try:
    from get_teams_by_conference_division import get_teams_by_conference_division
    from get_teams_for_specified_fan import get_teams_for_specified_fan
    from get_teams_in_same_conference_division_as_specified_team import (
        get_teams_in_same_conference_division_as_specified_team,
    )
    from validate_user import validate_user
except ModuleNotFoundError:
    from API.get_teams_by_conference_division import get_teams_by_conference_division
    from API.get_teams_for_specified_fan import get_teams_for_specified_fan
    from API.get_teams_in_same_conference_division_as_specified_team import (
        get_teams_in_same_conference_division_as_specified_team,
    )
    from API.validate_user import validate_user

app = FastAPI(title="NFL Playoffs API")


@app.get("/")
def read_root():
    return {"message": "NFL Playoffs API is running."}


@app.get("/teams/by-conference-division")
def read_teams_by_conference_division(
    conference_name: Optional[str] = Query(default=None),
    division_name: Optional[str] = Query(default=None),
):
    try:
        return get_teams_by_conference_division(conference_name, division_name)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@app.get("/teams/for-fan/{app_user_id}")
def read_teams_for_specified_fan(app_user_id: int):
    try:
        results = get_teams_for_specified_fan(app_user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc

    if not results:
        raise HTTPException(
            status_code=404,
            detail=f"No teams found for fan AppUserID '{app_user_id}'.",
        )

    return results


@app.get("/teams/same-conference-division/{team_name}")
def read_teams_in_same_conference_division(team_name: str):
    try:
        results = get_teams_in_same_conference_division_as_specified_team(team_name)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc

    if not results:
        raise HTTPException(
            status_code=404,
            detail=f"No teams found in the same conference/division as '{team_name}'.",
        )

    return results


@app.get("/validate-user")
def read_validated_user(
    email: str = Query(...),
    password: str = Query(...),
):
    try:
        return validate_user(email=email, password=password)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
