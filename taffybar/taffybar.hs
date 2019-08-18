{-# LANGUAGE OverloadedStrings #-}
module Main where

import           System.Taffybar                                 (startTaffybar)
import           System.Taffybar.SimpleConfig                    (barHeight, defaultSimpleTaffyConfig,
                                                                  endWidgets,
                                                                  startWidgets,
                                                                  toTaffyConfig)
import System.Taffybar.DBus (withToggleServer)
import System.Taffybar.Widget (minIcons, widgetGap, workspacesNew, defaultWorkspacesConfig)
import           System.Taffybar.Widget.Battery                  (textBatteryNew)
import           System.Taffybar.Widget.Layout                   (defaultLayoutConfig,
                                                                  layoutNew)

import           System.Taffybar.Widget.FreedesktopNotifications (defaultNotificationConfig,
                                                                  notifyAreaNew)
import           System.Taffybar.Widget.SimpleClock              (textClockNew)

import           System.Taffybar.Widget.SNITray                  (sniTrayNew, sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt)

import           System.Taffybar.Widget.Generic.PollingGraph     (defaultGraphConfig,
                                                                  graphDataColors,
                                                                  graphLabel,
                                                                  pollingGraphNew)
import           System.Taffybar.Widget.MPRIS2                   (mpris2New)

import           System.Taffybar.Information.CPU                 (cpuLoad)
import           System.Taffybar.Information.Memory              (memoryUsedRatio,
                                                                  parseMeminfo)

memCallback = do
  mi <- parseMeminfo
  return [memoryUsedRatio mi]

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

main :: IO ()
main = do

  let memCfg = defaultGraphConfig { graphDataColors = [(1, 0, 0, 1)]
                                  , graphLabel = Just "mem"
                                  }
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  , graphLabel = Just "cpu"
                                  }

      workspaces = workspacesNew $ defaultWorkspacesConfig
              { minIcons = 1
              , widgetGap = 0
              }

      clock = textClockNew Nothing "<span fgcolor='green'>%a %b %_d %H:%M</span>" 1
      note = notifyAreaNew defaultNotificationConfig
      tray = sniTrayNew -- sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt

      mem = pollingGraphNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback

      batt = textBatteryNew "B: $percentage$% ($time$) [$status$]"
      los = layoutNew defaultLayoutConfig

  startTaffybar . withToggleServer . toTaffyConfig $ defaultSimpleTaffyConfig
    { barHeight = 20
    , startWidgets = [ workspaces, los, note ]
    , endWidgets = [ batt, clock, mem, cpu, tray, mpris2New ]
    }
