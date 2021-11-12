--- xpcom/ds/NativeMenuAtoms.py.orig	2021-11-12 13:41:46 UTC
+++ xpcom/ds/NativeMenuAtoms.py
@@ -0,0 +1,9 @@
+from Atom import Atom
+
+NATIVE_MENU_ATOMS = [
+    Atom("menuitem_with_favicon", "menuitem-with-favicon"),
+    Atom("_moz_menubarkeeplocal", "_moz-menubarkeeplocal"),
+    Atom("_moz_nativemenupopupstate", "_moz-nativemenupopupstate"),
+    Atom("openedwithkey", "openedwithkey"),
+    Atom("shellshowingmenubar", "shellshowingmenubar"),
+]
