import           Control.Monad              (forM_, join)
import           Data.Function              (on)
import           Data.List                  (sortBy)
import qualified Data.Map                   as M
import           Data.Monoid                ((<>))

import qualified Graphics.X11.Types         as XT
import           XMonad                     (Full (..), Layout, ManageHook,
                                             Mirror (..), Tall (..), X,
                                             XConfig (..), def, spawn, windows, io,
                                             xmonad, (.|.), (|||), gets, windowset)
import           XMonad.Actions.SpawnOn     (manageSpawn, spawnOn)
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops  (ewmh)
import           XMonad.Hooks.ManageDocks   (avoidStruts, docks, manageDocks)
import           XMonad.ManageHook          (className, composeAll, doShift,
                                             (-->), (<+>), (=?))
import qualified XMonad.StackSet            as W
import           XMonad.Util.NamedWindows   (getName)
import           XMonad.Util.Run            (safeSpawn)

import           XMonad.Layout.Circle
import           XMonad.Layout.Grid
import           XMonad.Layout.ThreeColumns

-- Some keys for later
-- ((0, XT.xK_Print), spawn "maim -c 1,0,0,0.6 -s ~/screenshots/$(date +%F_%T).png")
-- , ((modm, XT.xK_Print), spawn "maim -s --format png -c 1,0,0,0.6 /dev/stdout | xclip -selection clipboard -t image/png -i")
--
spotifySend =
  mappend "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."

myKeys :: XConfig Layout -> M.Map (XT.ButtonMask, XT.KeySym) (X ())
myKeys conf@XConfig {modMask = modm} =
  let xK_X86MonBrightnessDown = 0x1008ff03
      xK_X86MonBrightnessUp   = 0x1008ff02
      xK_X86AudioLowerVolume  = 0x1008ff11
      xK_X86AudioRaiseVolume  = 0x1008ff13
      xK_X86AudioMute         = 0x1008ff12
      xK_X86AudioPlay         = 0x1008ff14
      xK_X86AudioPrev         = 0x1008ff16
      xK_X86AudioNext         = 0x1008ff17
      kees =
        M.fromList [ ((XT.controlMask .|. XT.mod1Mask, XT.xK_l), spawn "xscreensaver-command -lock")
                   , ((0, xK_X86MonBrightnessDown), spawn "xbacklight -dec 5")
                   , ((0, xK_X86MonBrightnessUp), spawn "xbacklight -inc 5")
                   , ((0, xK_X86AudioLowerVolume), spawn "amixer sset Master 5%-")
                   , ((0, xK_X86AudioRaiseVolume), spawn "amixer sset Master 5%+")
                   , ((0, xK_X86AudioMute), spawn "amixer sset Master toggle")
                   , ((0, xK_X86AudioPlay), spawn (spotifySend "PlayPause"))
                   , ((0, xK_X86AudioNext), spawn (spotifySend "Next"))
                   , ((0, xK_X86AudioPrev), spawn (spotifySend "Previous"))
                   ]
  in kees <> keys def conf

myLayout
  = ThreeColMid 1 (3/100) (1/2)
  ||| Tall nmaster delta ratio
  ||| Mirror (Tall nmaster delta ratio)
  ||| Full
  where
    nmaster = 1
    delta   = 3/100
    ratio   = 1/2

xmTitleLog, xmWorkspaceLog :: FilePath
xmTitleLog = "/tmp/.xmonad-title-log"
xmWorkspaceLog = "/tmp/.xmonad-workspace-log"

eventLogHook = do
  winset <- gets windowset
  title <- maybe (pure mempty) (fmap show . getName) . W.peek $ winset
  let
    currWs = W.currentTag winset
    wss = W.tag <$> W.workspaces winset
    wsStr = join . fmap (fmt currWs) $ sort' wss

  io $ appendFile xmTitleLog (title <> "\n")
  io $ appendFile xmWorkspaceLog (wsStr <> "\n")

  where
    sort' = sortBy (compare `on` (!! 0))

    fmt currWs ws
      | currWs == ws = "[" <> ws <> "]"
      | otherwise = " " <> ws <> " "

-- docks: add dock (panel) functionality to your configuration
-- ewmh: https://en.wikipedia.org/wiki/Extended_Window_Manager_Hints - lets XMonad talk to panels
main :: IO ()
main = do
  _ <- forM_ [xmTitleLog, xmWorkspaceLog] $ \l ->
    safeSpawn "mkfifo" [l]

  xmonad . docks $ def
    { keys = myKeys
    , modMask = XT.mod4Mask
    , terminal = "kitty" -- "alacritty" -- formerly "urxvt"
    -- avoidStruts tells windows to avoid the "strut" where docks live
    , layoutHook = avoidStruts myLayout
    , logHook = eventLogHook
    , manageHook = manageSpawn <+> manageDocks <+> manageHook def
    , workspaces =
      [ "1:code"
      , "2:browser (other)"
      , "3:browser (most)"
      , "4:musak"
      , "5:email"
      , "6"
      , "7"
      , "8"
      , "9"
      ]
    }
