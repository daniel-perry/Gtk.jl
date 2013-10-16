type GtkWindow <: GtkBin
    handle::Ptr{GtkObject}
    all::GdkRectangle
    function GtkWindow(title, w=-1, h=-1, resizable=true, toplevel=true)
        hnd = ccall((:gtk_window_new,libgtk),Ptr{GtkObject},(Enum,),
            toplevel?GtkWindowType.TOPLEVEL:GtkWindowType.POPUP)
        ccall((:gtk_window_set_title,libgtk),Void,(Ptr{GtkObject},Ptr{Uint8}),hnd,title)
        if resizable
            ccall((:gtk_window_set_default_size,libgtk),Void,(Ptr{GtkObject},Int32,Int32),hnd,w,h)
        else
            ccall((:gtk_window_set_resizable,libgtk),Void,(Ptr{GtkObject},Bool),hnd,false)
            ccall((:gtk_widget_set_size_request,libgtk),Void,(Ptr{GtkObject},Int32,Int32),hnd,w,h)
        end
        widget = new(hnd, GdkRectangle(0,0,w,h))
        on_signal_resize(notify_resize, widget)
        gtk_doevent()
        show(widget)
        gc_ref(widget)
    end
end

#GtkScrolledWindow
#GtkSeparator — A separator widget