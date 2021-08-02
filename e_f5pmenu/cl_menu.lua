Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil
local argent = {}
Conf              = {}
Conf.Title = "Votre serveur"

local cinematique = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

    ESX.PlayerData = ESX.GetPlayerData()
    
    while actualSkin == nil do
		TriggerEvent('skinchanger:getSkin', function(skin) actualSkin = skin end)
		Citizen.Wait(10)
	end

end)


RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	  ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	print(xPlayer)
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end

function startScenario(anim)
    TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function startAttitude(lib, anim)
	ESX.Streaming.RequestAnimSet(lib, function()
		SetPedMovementClipset(PlayerPedId(), anim, true)
	end)
end

function startAnim(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
	end)
end

local hasCinematic = true
function openCinematique()
	hasCinematic = not hasCinematic
    if not hasCinematic then -- montrer
        TriggerEvent("s_cinematique:cinematique", false)
        TriggerEvent("ui:off")
        TriggerEvent('ui:refresh')
		ESX.UI.HUD.SetDisplay(0.0)
		TriggerEvent('es:setMoneyDisplay', 0.0)
		TriggerEvent('esx_status:setDisplay', 0.0)
		DisplayRadar(false)
	elseif hasCinematic then -- cacher
		ESX.UI.HUD.SetDisplay(1.0)
		TriggerEvent('es:setMoneyDisplay', 1.0)
		TriggerEvent('esx_status:setDisplay', 1.0)
		DisplayRadar(true)
        TriggerEvent("s_cinematique:cinematique", true)
        TriggerEvent("ui:on")
        TriggerEvent('ui:refresh')
	end
end

function startAnimAction(lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
		RemoveAnimDict(lib)
	end)
end

function setUniform(value, plyPed)
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		TriggerEvent('skinchanger:getSkin', function(skina)
			if value == 'torso' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.torso_1 ~= skina.torso_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
				end
			elseif value == 'pants' then
				startAnimAction('re@construction', 'out_of_breath')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.pants_1 ~= skina.pants_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})
					end
				end
			elseif value == 'shoes' then
				startAnimAction('random@domestic', 'pickup_low')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.shoes_1 ~= skina.shoes_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})
				else
					if skin.sex == 0 then
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})
					else
						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})
					end
				end
			elseif value == 'bag' then
				startAnimAction('anim@heists@ornate_bank@grab_cash', 'intro')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.bags_1 ~= skina.bags_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})
				end
			elseif value == 'bproof' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.bproof_1 ~= skina.bproof_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})
				end
			elseif value == 'teef' then
				startAnimAction('clothingtie', 'try_tie_neutral_a')
				Citizen.Wait(1000)
				ClearPedTasks(plyPed)

				if skin.chain_1 ~= skina.chain_1 then
					TriggerEvent('skinchanger:loadClothes', skina, {['chain_1'] = skin.chain_1, ['chain_2'] = skin.chain_2})
				else
					TriggerEvent('skinchanger:loadClothes', skina, {['chain_1'] = 0, ['chain_2'] = 0})
				end
            elseif value == 'masque' then
                startAnimAction('mp_masks@standard_car@ds@', 'put_on_mask')
                Citizen.Wait(1000)
                ClearPedTasks(plyPed)

                if skin.mask_1 ~= skina.mask_1 then
                    TriggerEvent('skinchanger:loadClothes', skina, {['mask_1'] = skin.mask_1})
                else
                    TriggerEvent('skinchanger:loadClothes', skina, {['mask_1'] = -1})
                end
            elseif value == 'lunettes' then
                startAnimAction('clothingspecs', 'try_glasses_positive_a')
                Citizen.Wait(1000)
                ClearPedTasks(plyPed)

                if skin.glasses_1 ~= skina.glasses_1 then
                    TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = skin.glasses_1})
                else
                    TriggerEvent('skinchanger:loadClothes', skina, {['glasses_1'] = -1})
                end
            elseif value == 'chapeau' then
                startAnimAction('missfbi4', 'takeoff_mask')
                Citizen.Wait(1000)
                ClearPedTasks(plyPed)

                if skin.helmet_1 ~= skina.helmet_1 then
                    TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = skin.helmet_1})
                else
                    TriggerEvent('skinchanger:loadClothes', skina, {['helmet_1'] = -1})
                end
			end
		end)
	end)
end

function NotifSound()
    PlaySoundFrontend( -1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    ESX.ShowAdvancedNotification("Patrone", "Tien voila ~g~l'endroit travaille bien !", "", "CHAR_MOLLY", 1)
end

function RefreshMoney()
    Citizen.CreateThread(function()
            ESX.Math.GroupDigits(ESX.PlayerData.money)
            ESX.Math.GroupDigits(ESX.PlayerData.accounts[1].money)
            ESX.Math.GroupDigits(ESX.PlayerData.accounts[2].money)
    end)
end

-----------------------------------------------------------------------------------------------------------------
----------------------------------------------- Menu  -----------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

local argent = {
	"Regarder",
    "Donner"
}

local argentsale = {
	"Regarder",
    "Donner"
}

local metier = {
	"Regarder",
    "Action Patron"
}

local organisation = {
	"Regarder",
    "Action Boss"
}

local papiers = {
    "Regarder",
    "Montrer"
}

local entre = {
    "Recruter",
    "Promouvoir",
    "Rétrograder",
    "Virer"
}

local orga = {
    "Recruter",
    "Promouvoir",
    "Rétrograder",
    "Virer"
}

local vet = {
    "Haut",
    "Bas",
    "Chaussure"
}

local access = {
    "Masque",
    "Lunette",
    "Chapeau"
}

local divers = {
    "Chaîne",
    "Gilet par balle",
    "Sac"
}

local optionmoteur = {
    "Allumer",
    "Eteindre"
}

local porte = {
    "Avant Gauche",
    "Avant Droit",
    "Arrière Gauche",
    "Arrière Droit",
    "Capot",
    "Coffre",
    "Toutes les Portes"
}

local gps = {
    "Garage Central",
    "Commissariat",
    "Hopital",
    "Benny's",
    "Concessionnaire",
    "Auto école",
    "Pizzaeria"
}

local menuf5 = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 0, 0}, Title = Conf.Title},
    Data = { currentMenu = "Interaction :","Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
            PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			local slide = btn.slidenum
            local btn = btn.name
            local check = btn.unkCheckbox
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            local currentMenu = self.Data.currentMenu

            if btn == "Portefeuille" then
                OpenMenu("Portefeuille :")
            elseif btn == "Mes Papiers" then
                OpenMenu("Vos papiers :")
            elseif btn == "Mes Vêtements" then
                OpenMenu("Vêtement :")
            elseif btn == "Option Véhicule" then
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    OpenMenu("Gestion véhicule :")
                else
                    ESX.ShowNotification('Vous devez être dans un ~r~Véhicule !~s~')
                end
            elseif btn == "Autre" then
                OpenMenu("Divers option :")
            elseif btn == "DPemotes" then
                self:CloseMenu()
                TriggerEvent('dpemotes:OpenEmoteMenu')
            elseif btn == "Animation" then
                OpenMenu("Animation :")
            elseif btn == "Liste des Filtres" then
                OpenMenu("Filtre :")
---------------------------------------- Papier ----------------------------------------
            elseif slide == 1 and btn == "Carte d'Identité" then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
            elseif slide == 2 and btn == "Carte d'Identité" then
                if closestDistance ~= -1 and closestDistance <= 3 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
				else
					ESX.ShowNotification('Personne n\'est au alentour !')
				end
            elseif slide == 1 and btn == "Permis de conduire" then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
            elseif slide == 1 and btn == "Permis de conduire" then
                if closestDistance ~= -1 and closestDistance <= 3 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
				else
					ESX.ShowNotification('Personne n\'est au alentour !')
				end
            elseif slide == 1 and btn == "Permis de port d'arme" then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
            elseif slide == 1 and btn == "Permis de port d'arme" then
                if closestDistance ~= -1 and closestDistance <= 3 then
					TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
				else
					ESX.ShowNotification('Personne n\'est au alentour !')
				end
---------------------------------------- Argent ----------------------------------------
            elseif slide == 1 and btn == "Argent liquide" then
                RefreshMoney()
                ESX.ShowAdvancedNotification("Information - Argent", "", "Vous avez ~g~" ..ESX.Math.GroupDigits(ESX.PlayerData.money).. " $ ~s~ en Argent ~g~Liquide~s~", "CHAR_BANK_MAZE", 9)
            elseif slide == 2 and btn == "Argent liquide" then
                RefreshMoney()
                local quantity = KeyboardInput('SID_BOX_AMOUNT', 'Saisissez le Montant', '', 8)
                if quantity ~= nil then
                    local post = true
                    quantity = tonumber(quantity)
    
                    if type(quantity) == 'number' then
                        quantity = ESX.Math.Round(quantity)
    
                        if quantity <= 0 then
                            post = false
                        end
                    end
    
                    local foundPlayers = false
                    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        foundPlayers = true
                    end
    
                    if foundPlayers == true then
                        local closestPed = GetPlayerPed(closestPlayer)
    
                        if not IsPedSittingInAnyVehicle(closestPed) then
                            if post == true then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'money', quantity)
                            else
                                ESX.ShowNotification('Montant Invalide')
                            end
                        else
                            ESX.ShowNotification('Impossible de donner de l\'argent dans un véhicule')
                        end
                    else
                        ESX.ShowNotification('Personne n\'est au alentour !')
                    end
                end
            elseif slide == 1 and btn == "Argent Sale" then
                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == 'black_money' then
                        ESX.ShowAdvancedNotification("Information - Argent Sale", "", "Vous avez ~r~" ..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money).. " $~s~ en Argent ~r~Sale~s~", "CHAR_BANK_MAZE", 9)
                    end
                end
            elseif slide == 2 and btn == "Argent Sale" then
                local quantity = KeyboardInput('SID_BOX_AMOUNT', 'Saisissez le Montant', '', 8)

                if quantity ~= nil then
                    local post = true
                    quantity = tonumber(quantity)
    
                    if type(quantity) == 'number' then
                        quantity = ESX.Math.Round(quantity)
    
                        if quantity <= 0 then
                            post = false
                        end
                    end
    
                    local foundPlayers = false
                    closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                    if closestDistance ~= -1 and closestDistance <= 3 then
                        foundPlayers = true
                    end
    
                    if foundPlayers == true then
                        local closestPed = GetPlayerPed(closestPlayer)
    
                        if not IsPedSittingInAnyVehicle(closestPed) then
                            if post == true then
                                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'black_money', quantity)
                            else
                                ESX.ShowNotification('Montant Invalide')
                            end
                        else
                                ESX.ShowNotification('Impossible de donner de l\'argent sale dans un véhicule')
                        end
                    else
                        ESX.ShowNotification('Personne n\'est au alentour')
                    end
                end
--------------------------------------- Entreprise / Orga -----------------------------------------------------------
        elseif slide == 1 and btn == "Votre Métier" then
            ESX.ShowAdvancedNotification("Information - Métier", "", "Votre Métier est ~g~" ..ESX.PlayerData.job.label.. " ~s~ et votre grade est ~g~" ..ESX.PlayerData.job.grade_label.. "~s~", "CHAR_LIFEINVADER", 9)
        elseif slide == 2 and btn == "Votre Métier" then
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
            OpenMenu('Action Patron')
        else
            ESX.ShowNotification('~r~Vous devez être le Patron d\'une Entreprise pour Accéder à cette Option !~s~')
        end
        elseif slide == 1 and btn == "Votre Organisation" then
            ESX.ShowAdvancedNotification("Information - Organisation", "", "Votre Organisation est ~g~" ..ESX.PlayerData.job2.label.. " ~s~ et votre grade est ~g~" ..ESX.PlayerData.job2.grade_label.. "~s~", "CHAR_GANGAPP", 9)
        elseif slide == 2 and btn == "Votre Organisation" then
        if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
            OpenMenu('Action Boss')
        else
            ESX.ShowNotification('~r~Vous devez être le Boss d\'une Organisation pour Accéder à cette Option !~s~')
        end
        elseif slide == 1 and btn == "Gestion entreprise" then
            if ESX.PlayerData.job.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:recrutejoueur', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
                end
            else
                ESX.ShowNotification('missing_rights')
            end
        elseif slide == 2 and btn == "Gestion entreprise" then
            if ESX.PlayerData.job.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:promotionjoueur', GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification('missing_rights')
            end
        elseif slide == 3 and btn == "Gestion entreprise" then
            if ESX.PlayerData.job.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:retrojoueur', GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification('Personne a coté !')
            end
        elseif slide == 4 and btn == "Gestion entreprise" then
            if ESX.PlayerData.job.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:virerjoueur', GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification('Personne a coté !')
            end
        elseif slide == 1 and btn == "Gestion Organisation" then
            if ESX.PlayerData.job2.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:recrutejoueur2', GetPlayerServerId(closestPlayer), ESX.PlayerData.job2.name, 0)
                end
            else
                ESX.ShowNotification('missing_rights')
            end
        elseif slide == 2 and btn == "Gestion Organisation" then
            if ESX.PlayerData.job2.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:promotionjoueur2', GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification('missing_rights')
            end
        elseif slide == 3 and btn == "Gestion Organisation" then
            if ESX.PlayerData.job2.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:retrojoueur2', GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification('Personne a coté !')
            end
        elseif slide == 4 and btn == "Gestion Organisation" then
            if ESX.PlayerData.job2.grade_name == 'boss' then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Personne a coté !')
                else
                    TriggerServerEvent('e_f5:virerjoueur2', GetPlayerServerId(closestPlayer))
                end
            else
                ESX.ShowNotification('Personne a coté !')
            end
------------------------------------------------ Voiture --------------------------------------------------------
        elseif slide == 1 and btn == "Gérer le Moteur" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), true, false)   
        elseif slide == 2 and btn == "Gérer le Moteur" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), false, false)
        elseif slide == 1 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 0, false)
                else
                  SetVehicleDoorOpen(playerVeh, 0, false)
                  frontleft = true        
               end
            end
        elseif slide == 2 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 1, false)
                else
                  SetVehicleDoorOpen(playerVeh, 1, false)
                  frontleft = true        
               end
            end
        elseif slide == 3 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 2) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 2, false)
                else
                  SetVehicleDoorOpen(playerVeh, 2, false)
                  frontleft = true        
               end
            end
        elseif slide == 4 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 3) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 3, false)
                else
                  SetVehicleDoorOpen(playerVeh, 3, false)
                  frontleft = true        
               end
            end
        elseif slide == 5 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 4) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 4, false)
                else
                  SetVehicleDoorOpen(playerVeh, 4, false)
                  frontleft = true        
               end
            end
        elseif slide == 6 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 5) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 5, false)
                else
                  SetVehicleDoorOpen(playerVeh, 5, false)
                  frontleft = true        
               end
            end
        elseif slide == 7 and btn == "Gérer les Portes" then
            local playerPed = GetPlayerPed(-1)
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            if ( IsPedSittingInAnyVehicle( playerPed ) ) then
               if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
                  SetVehicleDoorShut(playerVeh, 5, false)        
                  SetVehicleDoorShut(playerVeh, 4, false)
                  SetVehicleDoorShut(playerVeh, 3, false)
                  SetVehicleDoorShut(playerVeh, 2, false)
                  SetVehicleDoorShut(playerVeh, 1, false)
                  SetVehicleDoorShut(playerVeh, 0, false)         
                else
                  SetVehicleDoorOpen(playerVeh, 5, false)        
                  SetVehicleDoorOpen(playerVeh, 4, false)
                  SetVehicleDoorOpen(playerVeh, 3, false)
                  SetVehicleDoorOpen(playerVeh, 2, false)
                  SetVehicleDoorOpen(playerVeh, 1, false)
                  SetVehicleDoorOpen(playerVeh, 0, false)  
                  frontleft = true        
               end
            end
-----------------------------  Animation ----------------------------------------------------------			
			elseif btn == "Fumer une cigarette" then                                      				
                startScenario('WORLD_HUMAN_SMOKING')
			elseif btn == "Fumer un joint" then                                      				
                startScenario('WORLD_HUMAN_SMOKING_POT')
			elseif btn == "Dj" then                                      				
				startAnim('anim@mp_player_intcelebrationmale@dj', 'dj')
			elseif btn == "Bourré sur place" then                                      				
				startAnim('amb@world_human_bum_standing@drunk@idle_a', 'idle_a')
			elseif btn == "Vomir en voiture" then                                      				
				startAnim('oddjobs@taxi@tie', 'vomit_outside')
			elseif btn == "Boire un café" then                                      				
				startAnim('amb@world_human_aa_coffee@idle_a', 'idle_a')
			elseif btn == "S'asseoir" then                                      				
				startAnim('anim@heists@prison_heistunfinished_biztarget_idle', 'target_idle')
			elseif btn == "Attendre contre un mur" then                                      				
				startScenario('world_human_leaning')
			elseif btn == "Couché sur le dos" then                                      				
				startScenario('WORLD_HUMAN_SUNBATHE_BACK')
			elseif btn == "Couché sur le ventre" then                                      				
				startScenario('WORLD_HUMAN_SUNBATHE')
			elseif btn == "Nettoyer quelque chose" then                                      				
				startScenario('world_human_maid_clean')
			elseif btn == "Préparer à manger" then                                      				
				startScenario('PROP_HUMAN_BBQ')
			elseif btn == "Position de Fouille" then                                      				
				startAnim('mini@prostitutes@sexlow_veh', 'low_car_bj_to_prop_female')
			elseif btn == "Prendre un selfie" then                                      				
				startScenario('world_human_tourist_mobile')
			elseif btn == "Ecouter à une porte" then                                      				
				startAnim('mini@safe_cracking', 'idle_base')
			elseif btn == "Montrer ses muscles" then                                      				
				startAnim('amb@world_human_muscle_flex@arms_at_side@base', 'base')
			elseif btn == "Faire des pompes" then                                      				
				startAnim('amb@world_human_push_ups@male@base', 'base')
			elseif btn == "Faire des abdos" then                                      				
				startAnim('amb@world_human_sit_ups@male@base', 'base')
			elseif btn == "Faire du yoga" then                                      				
				startAnim('amb@world_human_yoga@male@base', 'base_a')
			elseif btn == "Saluer" then                                      
				startAnim('gestures@m@standing@casual', 'gesture_hello')
			elseif btn == "Serrer la main" then                                      
				startAnim('mp_common', 'givetake1_a')
			elseif btn == "Tchek" then                                      				
				startAnim('mp_ped_interaction', 'handshake_guy_a')
			elseif btn == "Salut bandit" then                                      				
				startAnim('mp_ped_interaction', 'hugs_guy_a')
			elseif btn == "Salut Militaire" then                                      				
				startAnim('mp_player_int_uppersalute', 'mp_player_int_salute')
			elseif btn == "Normal M" then                                      				
				startAttitude('move_m@confident', 'move_m@confident')
			elseif btn == "Normal F" then                                      				
				startAttitude('move_f@heels@c', 'move_f@heels@c')
			elseif btn == "Depressif M" then                                      				
				startAttitude('move_m@depressed@a', 'move_m@depressed@a')
			elseif btn == "Depressif F" then                                      				
				startAttitude('move_f@depressed@a', 'move_f@depressed@a')
			elseif btn == "Business" then                                      				
				startAttitude('move_m@business@a', 'move_m@business@a')
			elseif btn == "Determine" then                                      				
				startAttitude('move_m@brave@a', 'move_m@brave@a')
			elseif btn == "Casual" then                                      				
				startAttitude('move_m@casual@a', 'move_m@casual@a')
			elseif btn == "Trop mangé" then                                      				
				startAttitude('move_m@fat@a', 'move_m@fat@a')
			elseif btn == "Hipster" then                                      				
				startAttitude('move_m@hipster@a', 'move_m@hipster@a')
			elseif btn == "Blesse" then                                      				
				startAttitude('move_m@injured', 'move_m@injured')
			elseif btn == "Intimide" then                                      				
				startAttitude('move_m@hurry@a', 'move_m@hurry@a')
			elseif btn == "Hobo" then                                      				
				startAttitude('move_m@hobo@a', 'move_m@hobo@a')
			elseif btn == "Malheureux" then                                      				
				startAttitude('move_m@sad@a', 'move_m@sad@a')
			elseif btn == "Muscle" then                                      				
				startAttitude('move_m@muscle@a', 'move_m@muscle@a')
			elseif btn == "Choc" then                                      				
				startAttitude('move_m@shocked@a', 'move_m@shocked@a')
			elseif btn == "Sombre" then                                      				
				startAttitude('move_m@shadyped@a', 'move_m@shadyped@a')
			elseif btn == "Fatigue" then                                      				
				startAttitude('move_m@buzzed', 'move_m@buzzed')
			elseif btn == "Pressee" then                                      				
				startAttitude('move_m@hurry_butch@a', 'move_m@hurry_butch@a')
			elseif btn == "Fier" then                                      				
				startAttitude('move_m@money', 'move_m@money')
			elseif btn == "Petite course" then                                      
				startAttitude('move_m@quick', 'move_m@quick')
			elseif btn == "Mangeuse d'homme" then                                      				
				startAttitude('move_f@maneater', 'move_f@maneater')
			elseif btn == "Impertinent" then                                      				
				startAttitude('move_f@sassy', 'move_f@sassy')
			elseif btn == "Arrogante" then                                      
			startAttitude('move_f@arrogant@a', 'move_f@arrogant@a')
----------------------------------------------------- Menu Divers ------------------------------------------------------------------
        elseif btn == "Synchroniser Votre Personnage" then
            Citizen.Wait(0)
            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
            ESX.ShowNotification('✅ Synchronisation effectuée.')
            self:CloseMenu()
        elseif btn == "Optimiser Vos FPS" then
            DoScreenFadeIn(2000) -- Ecran Noir
            LoadingPrompt('Optimisation en cours...')
            DoScreenFadeOut(2000)  -- Ecran Noir
            Citizen.Wait(2000)
            DoScreenFadeIn(1500) -- Ecran Noir
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            ClearHelp()
            ClearNotificationsPos()
            ClearPedInPauseMenu()
            ClearFloatingHelp()
            ClearGpsPlayerWaypoint()
            ClearGpsRaceTrack()
            ClearReminderMessage()
            ClearThisPrint()
            Citizen.Wait(2090)
            RemoveLoadingPrompt()
            Citizen.Wait(100)
            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
            ESX.ShowAdvancedNotification('Optimisation FPS', '', 'Optimisation ~g~effectuée~g~', 'CHAR_MP_FM_CONTACT', 8)
            self:CloseMenu()
        elseif btn == "Mon ID" then
            ESX.ShowAdvancedNotification("Information - ID", "", "Bonjour ~g~" ..GetPlayerName(PlayerId(-1)).. "~s~ votre ID est le Numéro ~g~" ..GetPlayerServerId(PlayerId(-1))..  "~s~", "CHAR_MP_FM_CONTACT", 7)
        elseif btn == "Mini maps (streamer)" then
            openCinematique()
        elseif btn == "Normal" then
            SetTimecycleModifier('')
        elseif btn == "Vue & lumières améliorées" then
            SetTimecycleModifier('tunnel')
        elseif btn == "Couleurs amplifiées" then
            SetTimecycleModifier('rply_saturation')
        elseif btn == "Noir & blancs" then
            SetTimecycleModifier('rply_saturation_neg')
-------------------------------------- Vêtement ------------------------------------
        elseif slide == 1 and btn == "Vêtement" then 
            setUniform('torso', plyPed)
        elseif slide == 2 and btn == "Vêtement" then 
            setUniform('pants', plyPed)
        elseif slide == 3 and btn == "Vêtement" then 
            setUniform('shoes', plyPed)
        elseif slide == 1 and btn == "Autres" then 
            setUniform('teef', plyPed)
        elseif slide == 2 and btn == "Autres" then 
            setUniform('bproof', plyPed)
        elseif slide == 3 and btn == "Autres" then 
            setUniform('bag', plyPed)
        elseif slide == 1 and btn == "Accessoire" then 
            setUniform('masque', plyPed)
        elseif slide == 2 and btn == "Accessoire" then 
            setUniform('lunettes', plyPed)
        elseif slide == 3 and btn == "Accessoire" then 
            setUniform('chapeau', plyPed)
-------------------------------------- Vêtement ------------------------------------
        elseif slide == 1 and btn == "GPS" then 
            SetNewWaypoint(-449.67, -340.83)
            NotifSound()
        elseif slide == 2 and btn == "GPS" then 
            SetNewWaypoint(425.13, -979.55)
            NotifSound()
        elseif slide == 3 and btn == "GPS" then 
            SetNewWaypoint(-33.88, -1102.37)
            NotifSound()
        elseif slide == 4 and btn == "GPS" then 
            SetNewWaypoint(-212.13, -1325.27)
            NotifSound()
        elseif slide == 5 and btn == "GPS" then 
            SetNewWaypoint(215.06, -791.56)
            NotifSound()
        elseif slide == 6 and btn == "GPS" then 
            SetNewWaypoint(-829.22, -696.99)
            NotifSound()
        elseif slide == 7 and btn == "GPS" then 
            SetNewWaypoint(-1285.73, -1387.15)
            NotifSound()
        end 
    end,
},
    Menu = {
        ["Interaction :"] = {
            b = {
                {name = "Portefeuille", ask = '>>', askX = true},
                {name = "Mes Vêtements", ask = ">>", askX = true},
                {name = "Option Véhicule", ask = ">>", askX = true},
                {name = "Animation", ask = ">>", askX = true},
                {name = "Autre", ask = ">>", askX = true},
                {name = "GPS", slidemax = gps},
                {name = "                             ~r~Created by Eivor", ask = "", askX = true},
            }
        },

        ["Portefeuille :"] = {
            b = {
                {name = "Votre Métier", slidemax = metier},
                {name = "Votre Organisation", slidemax = organisation},
                {name = "~g~↓                                  Argent                                     ↓", ask = "", askX = true},
                {name = "Argent liquide", slidemax = argent},
                {name = "Argent Sale", slidemax = argentsale},
                {name = "~g~↓                              Vos papiers                                  ↓", ask = "", askX = true},
                {name = "Mes Papiers", ask = ">>", askX = true},
            }
        },
        ["Vos papiers :"] = {
            b = {
                {name = "Carte d'Identité", slidemax = papiers},
                {name = "Permis de conduire", slidemax = papiers},
                {name = "Permis de port d'arme", slidemax = papiers},
            }
        },

        ["Animation :"] = {
            b = {
                {name = "DPemotes", ask = '>>', askX = true},
                {name = "Festives", ask = ">>", askX = true},
                {name = "Divers", ask = ">>", askX = true},
                {name = "Sport", ask = ">>", askX = true},
                {name = "Salutation", ask = ">>", askX = true},
            }
        },

        ["Action Patron"] = {
            b = {
                {name = "Gestion entreprise", slidemax = entre},
            }
        },

        ["Action Boss"] = {
            b = {
                {name = "Gestion Organisation", slidemax = orga},
            }
        },

        ["Vêtement :"] = {
            b = {
                {name = "Vêtement", slidemax = vet},
                {name = "Accessoire", slidemax = access},
                {name = "Autres", slidemax = divers},
            }
        },

        ["Gestion véhicule :"] = {
            b = {
                {name = "Gérer le Moteur", slidemax = optionmoteur},
                {name = "Gérer les Portes", slidemax = porte},
            }
        },

        ["Divers option :"] = {
            b = {
                {name = "Mon ID", ask = '>>', askX = true},
                {name = "Synchroniser Votre Personnage", ask = ">>", askX = true},
                {name = "Optimiser Vos FPS", ask = ">>", askX = true},
                {name = "~g~↓                                   Autre                                    ↓", ask = "", askX = true},
                {name = "Mini maps (streamer)", checkbox = false},
                {name = "Liste des Filtres", ask = ">>", askX = true},
            }
        },

        ["festives"] = {
            b = {
                {name = "Fumer une cigarette"},
                {name = "Fumer un joint"},
                {name = "Dj"},
                {name = "Bourré sur place"},
                {name = "Vomir en voiture"},
            }
        },
    
        ["divers"] = {
            b = {
                {name = "Boire un café"},
                {name = "S'asseoir"},
                {name = "Attendre contre un mur"},
                {name = "Couché sur le dos"},
                {name = "Couché sur le ventre"},
                {name = "Nettoyer quelque chose"},
                {name = "Préparer à manger"},
                {name = "Position de Fouille"},
                {name = "Prendre un selfie"},
                {name = "Ecouter à une porte"},
            }
        },
    
        ["sport"] = {
            b = {
                {name = "Montrer ses muscles"},
                {name = "Faire des pompes"},
                {name = "Faire des abdos"},
                {name = "Faire du yoga"},
            }
        },
    
        ["salutation"] = {
            b = {
                {name = "Saluer"},
                {name = "Serrer la main"},
                {name = "Tchek"},
                {name = "Salut bandit"},
                {name = "Salut Militaire"},
            }
        },
    
        ["démarches"] = {
            b = {
                {name = "Normal M"},
                {name = "Normal F"},
                {name = "Depressif M"},
                {name = "Depressif F"},
                {name = "Business"},
                {name = "Determine"},
                {name = "Casual"},
                {name = "Trop mangé"},
                {name = "Hipster"},
                {name = "Blesse"},
                {name = "Intimide"},
                {name = "Hobo"},
                {name = "Malheureux"},
                {name = "Muscle"},
                {name = "Choc"},
                {name = "Sombre"},
                {name = "Fatigue"},
                {name = "Pressee"},
                {name = "Fier"},
                {name = "Petite course"},
                {name = "Mangeuse d'homme"},
                {name = "Impertinent"},
                {name = "Arrogante"},
            }
        },

        ["Filtre :"] = {
            b = {
                {name = "Normal", ask = "", askX = true},
                {name = "Vue & lumières améliorées", ask = "", askX = true},
                {name = "Couleurs amplifiées", ask = "", askX = true},
                {name = "Noir & blancs", ask = "", askX = true},
            }
        },
    }
} 

------------------------------ Touche
local stopanim = {
    stop = Keys["X"],
}

Citizen.CreateThread(function()
	while true do
        plyPed = PlayerPedId()
		if IsControlPressed(1, stopanim.stop) then
            ClearPedTasks(plyPed)
		end
		Citizen.Wait(0)
	end
end)

local handsUP = {
	clavier1 = Keys["~"],
}

local handsup = false

function getSurrenderStatus()
	return handsup
end

RegisterNetEvent('KZ:getSurrenderStatusPlayer')
AddEventHandler('KZ:getSurrenderStatusPlayer', function(event, source)
	if handsup then
		TriggerServerEvent("KZ:reSendSurrenderStatus", event, source, true)
	else
		TriggerServerEvent("KZ:reSendSurrenderStatus", event, source, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local plyPed = PlayerPedId()

		if (IsControlJustPressed(1, handsUP.clavier1) or IsDisabledControlJustPressed(1, handsUP.clavier1)) then
			if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then
				if not IsPedInAnyVehicle(plyPed, false) and not IsPedSwimming(plyPed) and not IsPedShooting(plyPed) and not IsPedClimbing(plyPed) and not IsPedCuffed(plyPed) and not IsPedDiving(plyPed) and not IsPedFalling(plyPed) and not IsPedJumpingOutOfVehicle(plyPed) and not IsPedUsingAnyScenario(plyPed) and not IsPedInParachuteFreeFall(plyPed) then
					RequestAnimDict("random@mugging3")

					while not HasAnimDictLoaded("random@mugging3") do
						Citizen.Wait(100)
					end

					if not handsup then
						handsup = true
						TaskPlayAnim(plyPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
					elseif handsup then
						handsup = false
						ClearPedSecondaryTask(plyPed)
					end
				end
			end
		end
	end
end)

local pointing = {
	clavier2 = Keys["B"],
}

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Citizen.Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(1, pointing.clavier2) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Citizen.Wait(200)
                if not IsControlPressed(1, pointing.clavier2) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(1, pointing.clavier2) do
                        Citizen.Wait(50)
                    end
                end
            elseif (IsControlPressed(1, pointing.clavier2) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(1, pointing.clavier2) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
    end
end)

local crouch = {
	clavier3 = Keys["LEFTCTRL"],
}

local crouched = false
local GUI = {}
GUI.Time = 0

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)

        local plyPed = PlayerPedId()

        if DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then 
            DisableControlAction(1, crouch.clavier3, true)

            if not IsPauseMenuActive() then 
                if IsDisabledControlJustPressed(1, crouch.clavier3) then 
                    RequestAnimSet("move_ped_crouched")

                    while not HasAnimSetLoaded("move_ped_crouched") do 
                        Citizen.Wait(100)
                    end 

                    if crouched == true then 
                        ResetPedMovementClipset(plyPed, 0)
                        crouched = false 
                    elseif crouched == false then
                        SetPedMovementClipset(plyPed, "move_ped_crouched", 0.25)
                        crouched = true 
                    end 
					
					GUI.Time = GetGameTimer()
                end
            end 
        end 
    end
end)

------------------------------- Menu Ouverture

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
			if IsControlJustPressed(1,166) then 
                if abatardtufume then
                    if PlayerGroupe ~= nil  then
                        table.insert(menuf5.Menu["Menu interactions"].b)     
                    end
                    abatardtufume = false
                end
				CreateMenu(menuf5)
		end
    end
end)