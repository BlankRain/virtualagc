// -*- C++ -*- generated by wxGlade 0.6.3 on Thu Mar 26 15:34:04 2009

#include <wx/wx.h>
#include <wx/image.h>
// begin wxGlade: ::dependencies
// end wxGlade


#ifndef MESSAGEBOX_H
#define MESSAGEBOX_H


// begin wxGlade: ::extracode
// end wxGlade



class MyFrameClass: public wxFrame {
public:
    // begin wxGlade: MyFrameClass::ids
    // end wxGlade

    MyFrameClass(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_FRAME_STYLE);

private:
    // begin wxGlade: MyFrameClass::methods
    void set_properties();
    void do_layout();
    // end wxGlade

public:
    // begin wxGlade: MyFrameClass::attributes
    wxTextCtrl* Text;
    wxPanel* panel_1;
    // end wxGlade
}; // wxGlade: end class

class MyFrame: public wxFrame {
public:
// content of this block (ids) not found: did you rename this class?

    MyFrame(wxWindow* parent, int id, const wxString& title, const wxPoint& pos=wxDefaultPosition, const wxSize& size=wxDefaultSize, long style=wxDEFAULT_FRAME_STYLE);

private:
    void set_properties();
    void do_layout();

protected:
// content of this block (attributes) not found: did you rename this class?
}; // wxGlade: end class


#endif // MESSAGEBOX_H
