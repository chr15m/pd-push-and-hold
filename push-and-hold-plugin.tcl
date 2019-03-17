package require Tcl 8.4

package require pdwindow
package require pd_connect

variable send_release_event
set send_release_event 0

proc push_and_hold_release {tkcanvas kind x y b} {
  variable send_release_event
  set mytoplevel [winfo toplevel $tkcanvas]
  if $send_release_event {
    pdsend "#push-and-hold-release $mytoplevel $tkcanvas $kind [$tkcanvas canvasx $x] [$tkcanvas canvasy $y] $b"
  }
}

proc enable_push_and_hold { incoming } {
  variable send_release_event
  set send_release_event 1
  # ::pdwindow::post "push-and-hold plugin sending release events.\n"
}

proc patch_loaded {mytoplevel} {
  set tkcanvas [tkcanvas_name $mytoplevel]
  bind $tkcanvas <ButtonRelease-1>  "+push_and_hold_release %W up %x %y %b"
  ::pdwindow::post "push-and-hold plugin loaded. See push-and-hold object for help.\n"
  # ::pdwindow::post "push-and-hold plugin loaded. Use 'push-and-hold TOGGLESEND' object.\n"
}
bind all <<Loaded>> {patch_loaded %W}

::pd_connect::register_plugin_dispatch_receiver "push-and-hold" enable_push_and_hold
