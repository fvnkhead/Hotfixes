global function Hotfixes_Init

struct {
    bool handleInvalidPlayerName = true
} file

void function Hotfixes_Init()
{
    file.handleInvalidPlayerName = GetConVarBool("hotfix_invalid_player_name")

    if (file.handleInvalidPlayerName) {
        AddCallback_OnPlayerRespawned(InvalidPlayerName_OnPlayerRespawned)
    }
}

// couldn't find docs/examples on regexes so this will have to do
bool function IsValidLetter(int c) {
    // upper case
    if (65 <= c && c <= 90) {
        return true
    }

    // lower case
    if (97 <= c && c <= 122) {
        return true
    }

    // numbers
    if (48 <= c && c <= 57) {
        return true
    }

    // _ and -
    return c == 45 || c == 95
}

bool function IsValidName(string name) {
    if (name.len() < 4) {
        return false
    }

    for (int i = 0; i < name.len(); i++) {
        if (i > 32) {
            return false
        }

        if (!IsValidLetter(expect int(name[i]))) {
            return false
        }
    }

    return true
}

void function InvalidPlayerName_OnPlayerRespawned(entity player)
{
    string name = player.GetPlayerName()
    if (IsValidName(name)) {
        return
    }

    // shouldn't happen but who knows
    if (!IsAlive(player)) {
        return
    }

    player.Die()
    string msg = format("Player '%s'/'%s' killed due to invalid name", name, player.GetUID())
    Log(msg)
}

void function Log(string text)
{
    print("[fvnkhead.Hotfixes] " + text)
}
