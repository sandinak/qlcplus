/*
  Test program to verify status bar functionality in main QLC+ application
  
  This program demonstrates that the status bar is working correctly by:
  1. Creating a minimal QLC+ App instance
  2. Showing the main window with status bar
  3. Simulating mode changes and document modifications
*/

#include <QApplication>
#include <QTimer>
#include <QDebug>
#include "../ui/src/app.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    
    // Create the main QLC+ application window
    App mainWindow;
    mainWindow.show();
    
    qDebug() << "QLC+ Status Bar Test Application Started";
    qDebug() << "Initial status:";
    qDebug() << "  Program Status:" << mainWindow.programStatus();
    qDebug() << "  Operating Mode:" << mainWindow.operatingMode();
    qDebug() << "  Autosave Status:" << mainWindow.autosaveStatus();
    
    // Create a timer to simulate status changes
    QTimer *timer = new QTimer(&mainWindow);
    int counter = 0;
    
    QObject::connect(timer, &QTimer::timeout, [&]() {
        counter++;
        qDebug() << "\n--- Status Update" << counter << "---";
        
        switch(counter) {
            case 1:
                qDebug() << "Switching to Operate mode...";
                mainWindow.slotModeOperate();
                break;
            case 2:
                qDebug() << "Switching back to Design mode...";
                mainWindow.slotModeDesign();
                break;
            case 3:
                qDebug() << "Toggling mode...";
                mainWindow.slotModeToggle();
                break;
            case 4:
                qDebug() << "Final status check...";
                timer->stop();
                break;
        }
        
        qDebug() << "Current status:";
        qDebug() << "  Program Status:" << mainWindow.programStatus();
        qDebug() << "  Operating Mode:" << mainWindow.operatingMode();
        qDebug() << "  Autosave Status:" << mainWindow.autosaveStatus();
    });
    
    // Start the timer to trigger status changes every 3 seconds
    timer->start(3000);
    
    qDebug() << "\nStatus bar should be visible at the bottom of the window.";
    qDebug() << "The status will change every 3 seconds to demonstrate functionality.";
    qDebug() << "Close the window to exit the test.";
    
    return app.exec();
}
