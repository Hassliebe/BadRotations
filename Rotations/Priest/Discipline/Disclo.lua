local rotationName = "PangDisc"

-- Version: 1350-02-09-2020

local function createToggles()
    -- Cooldown Button
    CooldownModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Cooldowns Automated", tip = "Automatic Cooldowns - Boss Detection.", highlight = 1, icon = br.player.spell.divineStar},
        [2] = {mode = "On", value = 2, overlay = "Cooldowns Enabled", tip = "Cooldowns used regardless of target.", highlight = 0, icon = br.player.spell.divineStar},
        [3] = {mode = "Off", value = 3, overlay = "Cooldowns Disabled", tip = "No Cooldowns will be used.", highlight = 0, icon = br.player.spell.divineStar}
    }
    CreateButton("Cooldown", 1, 0)
    -- Defensive Button
    DefensiveModes = {
        [1] = {mode = "On", value = 1, overlay = "Defensive Enabled", tip = "Includes Defensive Cooldowns.", highlight = 1, icon = br.player.spell.powerWordBarrier},
        [2] = {mode = "Off", value = 2, overlay = "Defensive Disabled", tip = "No Defensives will be used.", highlight = 0, icon = br.player.spell.powerWordBarrier}
    }
    CreateButton("Defensive", 2, 0)
    -- Decurse Button
    DecurseModes = {
        [1] = {mode = "On", value = 1, overlay = "Decurse Enabled", tip = "Decurse Enabled", highlight = 1, icon = br.player.spell.purify},
        [2] = {mode = "Off", value = 2, overlay = "Decurse Disabled", tip = "Decurse Disabled", highlight = 0, icon = br.player.spell.purify}
    }
    CreateButton("Decurse", 3, 0)
    -- Interrupt Button
    InterruptModes = {
        [1] = {mode = "On", value = 1, overlay = "Interrupts Enabled", tip = "Includes Basic Interrupts.", highlight = 1, icon = br.player.spell.psychicScream},
        [2] = {mode = "Off", value = 2, overlay = "Interrupts Disabled", tip = "No Interrupts will be used.", highlight = 0, icon = br.player.spell.psychicScream}
    }
    CreateButton("Interrupt", 4, 0)
    BurstModes = {
        [1] = {mode = "Auto", value = 1, overlay = "Auto Ramp Enabled", tip = "Will Automatically Ramp based on DBM", highlight = 1, icon = br.player.spell.powerWordShield},
        [2] = {mode = "Ramp", value = 2, overlay = "Manual Ramp Disabled", tip = "Manually Ramping for damage", highlight = 0, icon = br.player.spell.powerWordShield},
        [3] = {mode = "Hold", value = 3, overlay = "Ramp Disabled", tip = "No Ramp Logic.", highlight = 0, icon = br.player.spell.powerWordShield}
    }
    CreateButton("Burst", 0, -1)
end

local function createOptions()
    local optionTable

    local function generalOptions()
        -------------------------
        -------- UTILITY --------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "General")
        br.ui:createCheckbox(section, "Enemy Target Lock")
        br.ui:createCheckbox(section, "Heal OoC")
        br.ui:createCheckbox(section, "Power Word: Fortitude", "Maintain Fort Buff on Group")
        br.ui:createDropdown(section, "Dispel Magic", {"Only Target", "Auto"}, 1, "Dispel Target or Auto")
        br.ui:createDropdown(section, "Mass Dispel", br.dropOptions.Toggle, 1, "Select Key for Auto Dispel")
        br.ui:createSpinner(section, "Body and Soul", 2, 0, 100, 1, "Movement (seconds) before Body and Soul")
        br.ui:createSpinner(section, "Angelic Feather", 2, 0, 100, 1, "Movement (seconds) before Feather")
        br.ui:createSpinner(section, "Fade", 95, 0, 100, 1, "Health to cast Fade if agro")
        br.ui:checkSectionState(section)

        section = br.ui:createSection(br.ui.window.profile, "Interrupts")
        br.ui:createCheckbox(section, "Shining Force - Int")
        br.ui:createCheckbox(section, "Psychic Scream - Int")
        if br.player.race == "Pandaren" then
            br.ui:createCheckbox(section, "Quaking Palm - Int")
        end
        br.ui:createSpinner(section, "Interrupt At", 0, 0, 95, 5, "Cast Percent to Cast At. Default: 0")
        br.ui:checkSectionState(section)
    end

    local function healingOptions()
        -------------------------
        ---- SINGLE TARGET ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Single Target Healing")
        --Atonement
        br.ui:createCheckbox(section, "Obey Atonement Limits")
        br.ui:createSpinnerWithout(section, "Tank Atonement HP", 95, 0, 100, 1, "Apply Atonement to Tank using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
        br.ui:createSpinnerWithout(section, "Party Atonement HP", 95, 0, 100, 1, "Apply Atonement using Power Word: Shield and Power Word: Radiance. Health Percent to Cast At. Default: 95")
        br.ui:createSpinnerWithout(section, "Max Atonements", 3, 1, 40, 1, "Max Atonements to Keep Up At Once. Default: 3")
        br.ui:createDropdown(section, "Atonement Key", br.dropOptions.Toggle, 6, "Set key to press to spam atonements on everyone.")
        br.ui:createSpinner(section, "Heal Counter", 1, 1, 5, 1, "How many Heals to check before damaging")
        br.ui:createSpinner(section, "Shadow Mend", 65, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Penance Heal", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Pain Suppression Tank", 30, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Pain Suppression Party", 30, 0, 100, 5, "Health Percent to Cast At")
        if br.player.level < 28 then
            br.ui:createSpinner(section, "Low Level Flash Heal",60, 0, 100, 5)
        end

        br.ui:checkSectionState(section)
        -------------------------
        ------ AOE HEALING ------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "AOE Healing")
        --Power Word: Radiance
        br.ui:createSpinner(section, "Power Word: Radiance", 70, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "PWR Targets", 3, 0, 40, 1, "Minimum PWR Targets")
        --Shadow Covenant
        br.ui:createSpinner(section, "Shadow Covenant", 85, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Shadow Covenant Targets", 4, 0, 40, 1, "Minimum Shadow Covenant Targets")
        br.ui:checkSectionState(section)
    end
    local function damageOptions()
        -------------------------
        ----- DAMAGE OPTIONS ----
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Damage")
        br.ui:createSpinnerWithout(section, "Damage Mana Threshold")
        br.ui:createCheckbox(section, "Shadow Word: Pain/Purge The Wicked")
        br.ui:createSpinnerWithout(section, "SW:P/PtW Targets", 3, 0, 20, 1, "Maximum SW:P/PtW Targets")
        br.ui:createCheckbox(section, "Schism")
        br.ui:createCheckbox(section, "Penance")
        br.ui:createCheckbox(section, "Power Word: Solace")
        br.ui:createCheckbox(section, "Smite")
        br.ui:createSpinner(section, "Mindbender", 80, 0, 100, 5, "Mana Percent to Cast At")
        br.ui:createSpinner(section, "Shadowfiend", 80, 0, 100, 5, "Health Percent to Cast At")
        br.ui:checkSectionState(section)
    end
    local function cooldownOptions()
        -------------------------
        ------- COOLDOWNS -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Cooldowns")
        --Rapture when get Innervate
        br.ui:createCheckbox(section, "Rapture when get Innervate", "Auto Rapture when Innervated")
        --Rapture
        br.ui:createCheckbox(section, "Auto Rapture", "Auto Use Rapture based on DBM")
        br.ui:createSpinner(section, "Rapture", 60, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Rapture Targets", 3, 0, 40, 1, "Minimum Rapture Targets")
        --Evangelism
        br.ui:createSpinner(section, "Evangelism", 70, 0, 100, 1, "Health Percent to Cast At")
        br.ui:createSpinnerWithout(section, "Evangelism Targets", 3, 0, 40, 1, "Target count to Cast At")
        br.ui:createSpinnerWithout(section, "Atonement for Evangelism", 3, 0, 40, 1, "Minimum Atonement count to Cast At")
        br.ui:checkSectionState(section)
    end
    local function defenseOptions()
        -------------------------
        ------- DEFENSIVE -------
        -------------------------
        section = br.ui:createSection(br.ui.window.profile, "Defensive")
        br.ui:createSpinner(section, "Desperate Prayer", 40, 0, 100, 5, "Health Percent to Cast At")
        br.ui:createSpinner(section, "Pot / Healthstone", 35, 0, 100, 5, "Health Percent to Cast At")
        if br.player.race == "Draenei" then
            br.ui:createSpinner(section, "Gift of the Naaru", 50, 0, 100, 5, "Health Percent to Cast At")
        end
        br.ui:checkSectionState(section)
    end
    optionTable = {
        {
            [1] = "General",
            [2] = generalOptions
        },
        {
            [1] = "Healing",
            [2] = healingOptions
        },
        {
            [1] = "Damage",
            [2] = damageOptions
        },
        {
            [1] = "Cooldowns",
            [2] = cooldownOptions
        },
        {
            [1] = "Defensive",
            [2] = defenseOptions
        }
    }
    return optionTable
end

local function runRotation()
    local buff = br.player.buff
    local cast = br.player.cast
    local combatTime = getCombatTime()
    local cd = br.player.cd
    local charges = br.player.charges
    local debuff = br.player.debuff
    local enemies = br.player.enemies
    local essence = br.player.essence
    local falling, swimming, flying, moving = getFallTime(), IsSwimming(), IsFlying(), GetUnitSpeed("player") > 0
    local freeMana = buff.innervate.exists() or buff.symbolOfHope.exists()
    local friends = friends or {}
    local gcd = br.player.gcd
    local gcdMax = br.player.gcdMax
    local healPot = getHealthPot()
    local inCombat = br.player.inCombat
    local inInstance = br.player.instance == "party"
    local inRaid = br.player.instance == "raid"
    local lastSpell = lastSpellCast
    local level = br.player.level
    local lootDelay = getOptionValue("LootDelay")
    local lowest = br.friend[1]
    local mana = getMana("player")
    local mode = br.player.mode
    local perk = br.player.perk
    local php = br.player.health
    local power, powmax, powgen = br.player.power.mana.amount(), br.player.power.mana.max(), br.player.power.mana.regen()
    local pullTimer = br.DBM:getPulltimer()
    local race = br.player.race
    local racial = br.player.getRacial()
    local solo = #br.friend == 1
    local spell = br.player.spell
    local tanks = getTanksTable()
    local talent = br.player.talent
    local ttd = getTTD
    local traits = br.player.traits
    local ttm = br.player.power.mana.ttm()
    local units = br.player.units
    local schismCount = debuff.schism.count()

    units.get(5)
    units.get(30)
    units.get(40)
    enemies.get(24)
    enemies.get(30)
    enemies.get(40)
    friends.yards40 = getAllies("player", 40)

    local atonementCount = 0
    local maxAtonementCount = 0
    local schismBuff
    local ptwDebuff


    if isChecked("Enemy Target Lock") then
        if (UnitIsFriend("target", "player") or UnitIsDeadOrGhost("target")) then
            TargetLastEnemy()
        end
    end

    -- set penance target
    for i = 1, #enemies.yards40 do
        local thisUnit = enemies.yards40[i]

        if debuff.schism.exists(thisUnit) then
            schismBuff = thisUnit
        end

        if debuff.purgeTheWicked.exists(thisUnit) then
            ptwDebuff = thisUnit
        end
    end

    -- Atonement Count
    for i = 1, #br.friend do
        local atonementRemain = getBuffRemain(br.friend[i].unit, spell.buffs.atonement, "player") or 0 -- 194384
        if atonementRemain > 0 then
            if (br.friend[i].role ~= "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) ~= "TANK") then
                maxAtonementCount = maxAtonementCount + 1
                atonementCount = atonementCount + 1
            else
                atonementCount = atonementCount + 1
            end
        end
    end

    notAtoned = 0
    for i = 1, #br.friend do
        thisUnit = br.friend[1].unit
        if not buff.atonement.exists(thisUnit) then
            notAtoned = notAtoned + 1
        end
    end

    local current
    local function ptwTargets()
        current = 0
        for i = 1, #enemies.yards40 do
            local thisUnit = enemies.yards40[i]
            if debuff.purgeTheWicked.exists(thisUnit) or debuff.shadowWordPain.exists(thisUnit) then
                current = current + 1
            end
        end
        return current
    end

    ---------------------
    ----- APL LISTS -----
    ---------------------
    local function Interruptstuff()
        if useInterrupts() then
            for i = 1, #enemies.yards40 do
                thisUnit = enemies.yards40[i]
                if canInterrupt(thisUnit, getOptionValue("Interrupt At")) then
                    if isChecked("Shining Force - Int") and getDistance(thisUnit) < 40 then
                        if cast.shiningForce() then
                            return
                        end
                    end
                    if isChecked("Psychic Scream - Int") and getDistance(thisUnit) < 8 then
                        if cast.psychicScream() then
                            return
                        end
                    end
                    if isChecked("Quaking Palm - Int") and getDistance(thisUnit) < 5 then
                        if cast.quakingPalm(thisUnit) then
                            return
                        end
                    end
                end
            end
        end
    end

    local function DefensiveTime()
        if useDefensive() then
            if isChecked("Pot / Healthstone") and php <= getOptionValue("Pot / Healthstone") and inCombat and (hasHealthPot() or hasItem(5512) or hasItem(166799)) then
                if canUseItem(5512) then
                    useItem(5512)
                elseif canUseItem(healPot) then
                    useItem(healPot)
                elseif hasItem(166799) and canUseItem(166799) then
                    useItem(166799)
                end
            end
            -- Gift of the Naaru
            if isChecked("Gift of the Naaru") and php <= getOptionValue("Gift of the Naaru") and php > 0 and br.player.race == "Draenei" then
                if cast.giftOfTheNaaru() then
                    return
                end
            end
            if isChecked("Desperate Prayer") and php <= getOptionValue("Desperate Prayer") then
                if cast.desperatePrayer() then
                    return
                end
            end
        end
    end

    local function CooldownTime()
        if useCDs() then
            -- Pain Suppression
            if isChecked("Pain Suppression Tank") and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression Tank") and UnitGroupRolesAssigned(br.friend[i].unit) == "TANK" then
                        if cast.painSuppression(br.friend[i].unit) then
                            return
                        end
                    end
                end
            end
            if isChecked("Pain Suppression Party") and inCombat then
                for i = 1, #br.friend do
                    if br.friend[i].hp <= getValue("Pain Suppression Tank") then
                        if cast.painSuppression(br.friend[i].unit) then
                            return
                        end
                    end
                end
            end
            if isChecked("PW:B/LB") then
                if isChecked("PW:B/LB on Melee") then
                    -- get melee players
                    for i = 1, #tanks do
                        -- get the tank's target
                        local tankTarget = UnitTarget(tanks[i].unit)
                        if tankTarget ~= nil and getDistance(tankTarget) <= 40 then
                            -- get players in melee range of tank's target
                            local meleeFriends = getAllies(tankTarget, 5)
                            -- get the best ground circle to encompass the most of them
                            local loc = nil
                            local meleeHurt = {}
                            for j = 1, #meleeFriends do
                                if meleeFriends[j].hp < getValue("PW:B/LB") then
                                    tinsert(meleeHurt, meleeFriends[j])
                                end
                            end
                            if #meleeHurt >= getValue("PW:B/LB Targets") then
                                loc = getBestGroundCircleLocation(meleeHurt, getValue("PW:B/LB Targets"), 6, 8)
                            end
                            if loc ~= nil then
                                if talent.luminousBarrier then
                                    if castGroundAtLocation(loc, spell.luminousBarrier) then
                                        return
                                    end
                                else
                                    if castGroundAtLocation(loc, spell.powerWordBarrier) then
                                        return
                                    end
                                end
                            end
                        end
                    end
                else
                    if talent.luminousBarrier then
                        if castWiseAoEHeal(br.friend, spell.luminousBarrier, 10, getValue("PW:B/LB"), getValue("PW:B/LB Targets"), 6, true, true) then
                            return
                        end
                    else
                        if castWiseAoEHeal(br.friend, spell.powerWordBarrier, 10, getValue("PW:B/LB"), getValue("PW:B/LB Targets"), 6, true, true) then
                            return
                        end
                    end
                end
            end
            if isChecked("Rapture when get Innervate") and freeMana then
                if cast.rapture() then
                    return
                end
            end
            if isChecked("Rapture") then
                if getLowAllies(getValue("Rapture")) >= getValue("Rapture Targets") then
                    if cast.rapture() then
                        return
                    end
                end
            end
            if (race == "Troll" or race == "Orc" or race == "MagharOrc" or race == "DarkIronDwarf" or race == "LightforgedDraenei") or (mana >= 30 and race == "BloodElf") then
                if race == "LightforgedDraenei" then
                    if cast.racial("target", "ground") then
                        return
                    end
                else
                    if cast.racial("player") then
                        return
                    end
                end
            end
        end
    end

    local function Dispelstuff()
        if mode.decurse == 1 then
            if isChecked("Dispel Magic") then
                if getOptionValue("Dispel Magic") == 1 then
                    if canDispel("target", spell.dispelMagic) and GetObjectExists("target") then
                        if cast.dispelMagic("target") then
                            br.addonDebug("Casting Dispel Magic")
                            return
                        end
                    end
                elseif getOptionValue("Dispel Magic") == 2 then
                    for i = 1, #enemies.yards30 do
                        local thisUnit = enemies.yards30[i]
                        if canDispel(thisUnit, spell.dispelMagic) then
                            if cast.dispelMagic(thisUnit) then
                                br.addonDebug("Casting Dispel Magic")
                                return
                            end
                        end
                    end
                end
            end
            --Purify
            for i = 1, #br.friend do
                if canDispel(br.friend[i].unit, spell.purify) then
                    if cast.purify(br.friend[i].unit) then
                        return
                    end
                end
            end
        end
    end

    local function Extrastuff()
        if IsMovingTime(getOptionValue("Angelic Feather")) and not IsSwimming() then
            if not runningTime then
                runningTime = GetTime()
            end
            if isChecked("Angelic Feather") and talent.angelicFeather and (not buff.angelicFeather.exists("player") or GetTime() > runningTime + 5) then
                if cast.angelicFeather("player") then
                    runningTime = GetTime()
                    SpellStopTargeting()
                end
            end
        end
        if IsMovingTime(getOptionValue("Body and Soul")) then
            if bnSTimer == nil then
                bnSTimer = GetTime() - 6
            end
            if isChecked("Body and Soul") and talent.bodyAndSoul and not buff.bodyAndSoul.exists("player") and GetTime() >= bnSTimer + 6 then
                if cast.powerWordShield("player") then
                    bnSTimer = GetTime()
                    return
                end
            end
        end
        if isChecked("Power Word: Fortitude") and br.timer:useTimer("PW:F Delay", math.random(20, 50)) then
            for i = 1, #br.friend do
                if not buff.powerWordFortitude.exists(br.friend[i].unit, "any") and getDistance("player", br.friend[i].unit) < 40 and not UnitIsDeadOrGhost(br.friend[i].unit) and UnitIsPlayer(br.friend[i].unit) then
                    if cast.powerWordFortitude() then
                        return
                    end
                end
            end
        end
    end

    local function HealingTime()
        -- Atonement Key
        if (SpecificToggle("Atonement Key") and not GetCurrentKeyBoardFocus()) and isChecked("Atonement Key") then
            for i = 1, #br.friend do
                local thisUnit = br.friend[i].unit
                if not buff.atonement.exists(thisUnit) then
                    if notAtoned >= getOptionValue("Minimum PWR Targets") and not isMoving("player") then
                        if cast.powerWordRadiance(thisUnit) then 
                            return true
                        end
                    elseif notAtoned <= getOptionValue("Minimum PWR Targets") or charges.powerWordRadiance.frac() < 1 and not debuff.weakenedSoul.exists(thisUnit) then
                        if cast.powerWordShield(thisUnit) then
                            return true
                        end
                    end
                end
                if isChecked("Evangelism") and atonementCount >= getOptionValue("Atonement for Evangelism") and (charges.powerWordRadiance.count() == 0 or notAtoned <= getOptionValue("Minimum PWR Targets")) then
                    if cast.evangelism() then
                        return true
                    end
                end
            end
        end

        if buff.rapture.exists("player") then
            if isChecked("Obey Atonement Limits") then
                for i = 1, #br.friend do
                    if maxAtonementCount < getValue("Max Atonements") or (br.friend[i].role == "TANK" or UnitGroupRolesAssigned(br.friend[i].unit) == "TANK") then
                        if getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                            if cast.powerWordShield(br.friend[i].unit) then
                                return true
                            end
                        end
                    end
                    if maxAtonementCount >= getValue("Max Atonements") then
                        if cast.powerWordShield(lowest.unit) then
                            return true
                        end
                    end
                end
            else
                for i = 1, #br.friend do
                    if not buff.atonement.exists(br.friend[i].unit) and getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then
                            return true
                        end
                    end
                end
                for i = 1, #br.friend do
                    if getBuffRemain(br.friend[i].unit, spell.buffs.powerWordShield, "player") < 1 then
                        if cast.powerWordShield(br.friend[i].unit) then
                            return true
                        end
                    end
                end
            end
        end

        if isChecked("Evangelism") and talent.evangelism and (atonementCount >= getValue("Atonement for Evangelism") or (not inRaid and atonementCount >= 3)) and not buff.rapture.exists("player") then
            if getLowAllies(getValue("Evangelism")) >= getValue("Evangelism Targets") then
                if cast.evangelism() then
                    return true
                end
            end
        end

        if isChecked("Power Word: Radiance") and notAtoned > 2 and not cast.last.powerWordRadiance() then
            if charges.powerWordRadiance.count() >= 1 then
                if getLowAllies(getValue("Power Word: Radiance")) >= getValue("PWR Targets") then
                    for i = 1, #br.friend do
                        if not buff.atonement.exists(br.friend[i].unit) and br.friend[i].hp <= getValue("Power Word: Radiance") and not isMoving("player") then
                            if cast.powerWordRadiance(br.friend[i].unit) then
                                return true
                            end
                        end
                    end
                end
            end
        end

        if isChecked("Shadow Covenant") and talent.shadowCovenant then
            if getLowAllies(getValue("Shadow Covenant")) >= getValue("Shadow Covenant Targets") then
                if cast.shadowCovenant(lowest.unit) then
                    return true
                end
            end
        end

        if (isChecked("Penance Heal") and talent.contrition and atonementCount >= 3) or (isChecked("Heal OoC") and not inCombat and lowest.hp <= 95) or level < 28 and lowest.hp < getOptionValue("Penance Heal") then
            if cast.penance(lowest.unit) then
                return true
            end
        end

        if isChecked("Shadow Mend") and not isMoving("player") then
            for i = 1, #br.friend do
                if (br.friend[i].hp <= getValue("Shadow Mend") and (not buff.atonement.exists(br.friend[i].unit) or not IsInRaid())) or (isChecked("Heal OoC") and not inCombat and lowest.hp <= 95) then
                    if cast.shadowMend(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end

        for i = 1, #tanks do
            if (tanks[i].hp <= getOptionValue("Tank Atonement HP") or getValue("Tank Atonement HP") == 100) and not buff.atonement.exists(tanks[i].unit) and not debuff.weakenedSoul.exists(tanks[i].unit) then
                if cast.powerWordShield(tanks[i].unit) then
                    return true
                end
            end
        end

        for i = 1, #br.friend do
            if (br.friend[i].hp <= getOptionValue("Party Atonement HP") or getOptionValue("Party Atonement HP") == 100) and not debuff.weakenedSoul.exists(br.friend[i].unit) and not buff.atonement.exists(br.friend[i].unit) and (maxAtonementCount < getValue("Max Atonements") or not isChecked("Obey Atonement Limits")) then
                if cast.powerWordShield(br.friend[i].unit) then
                    return true
                end
            end
        end

        if level < 28 then
            for i = 1, #br.friend do
                if isChecked("Low Level Flash Heal") and br.friend[i].hp <= getOptionValue("Low Level Flash Heal") then
                    if cast.flashHeal(br.friend[i].unit) then
                        return true
                    end
                end
            end
        end
    end

    local function DamageTime()
        if isChecked("Shadow Word: Pain/Purge The Wicked") and (getSpellCD(spell.penance) > gcdMax or (getSpellCD(spell.penance) <= gcdMax and debuff.purgeTheWicked.count() == 0)) then
            if talent.purgeTheWicked then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ptwTargets() < getValue("SW:P/PtW Targets") then
                        if GetUnitIsUnit(thisUnit, "target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                            if debuff.purgeTheWicked.remain(thisUnit) < 6 then
                                if cast.purgeTheWicked(thisUnit) then
                                    ptwDebuff = thisUnit
                                    return
                                end
                            end
                        end
                    end
                end
            end
            if not talent.purgeTheWicked then
                for i = 1, #enemies.yards40 do
                    local thisUnit = enemies.yards40[i]
                    if ptwTargets() < getValue("SW:P/PtW Targets") then
                        if GetUnitIsUnit(thisUnit, "target") or hasThreat(thisUnit) or isDummy(thisUnit) then
                            if debuff.shadowWordPain.remain(thisUnit) < 4.8 then
                                if cast.shadowWordPain(thisUnit) then
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Mindbender
        if isChecked("Mindbender") and mana <= getValue("Mindbender") and atonementCount >= 3 and talent.mindbender then
            if schismBuff ~= nil then
                if cast.mindbender(schismBuff) then
                    return
                end
            elseif cast.mindbender() then
               return
            end
        end
        -- Shadowfiend
        if isChecked("Shadowfiend") and not talent.mindbender and atonementCount >= 3 then
            if schismBuff ~= nil then
                if cast.shadowfiend(schismBuff) then
                   return
                end
            elseif cast.shadowfiend() then
                return
            end
        end

        if talent.schism and isChecked("Schism") and cd.penance.remain() <= gcdMax and not isMoving("player") and ttd("target") > 9 and not isExplosive("target") then
            if cast.schism("target") then
                return
            end
        end

        if isChecked("Power Word: Solace") and talent.powerWordSolace then
            if schismBuff ~= nil then
                if cast.powerWordSolace(schismBuff) then
                    return
                end
            elseif schismBuff == nil then
                if cast.powerWordSolace("target") then
                    return
                end
            end
        end

        if isChecked("Penance") then
            if schismBuff ~= nil then
                if cast.penance(schismBuff) then
                    return
                end
            elseif ptwDebuff ~= nil and schismBuff == nil then
                if cast.penance(ptwDebuff) then
                    return
                end
            elseif (not schismBuff or ptwDebuff) then
                if cast.penance("target") then
                   return
                end
            end
        end

        if isChecked("Smite") and not isMoving("player") then
            if schismBuff ~= nil then
                if cast.smite(schismBuff) then
                    return
                end
            elseif cast.smite() then
                return
            end
        end
    end
 

    ------------------------------
    ------- Start the Stuff ------
    if pause() or drinking then
        return
    else
        if not inCombat then
            if isChecked("Heal OoC") then
                if HealingTime() then return true end
            end
            if Extrastuff() then return end
            if Dispelstuff() then return end
        elseif inCombat then
            if Extrastuff() then return end
            if Dispelstuff() then return end
            if Interruptstuff() then return end
            if DefensiveTime() then return end
            if CooldownTime() then return end
            if discHealCount < getOptionValue("Heal Counter") or not isChecked("Heal Counter") then
                if HealingTime() then return true end
            end
            if DamageTime() then return end
        end
    end
end

local id = 256
if br.rotations[id] == nil then
    br.rotations[id] = {}
end
tinsert(
    br.rotations[id],
    {
        name = rotationName,
        toggles = createToggles,
        options = createOptions,
        run = runRotation
    }
)