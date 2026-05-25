#include <QApplication>
#include <QTest>
#include <QTimer>
#include <QDebug>

#include "ui/src/functionselection.h"
#include "ui/src/app.h"
#include "engine/src/doc.h"
#include "engine/src/scene.h"
#include "engine/src/mastertimer.h"

class TestFunctionSelectionFix : public QObject
{
    Q_OBJECT

private slots:
    void initTestCase();
    void testFunctionSelectionRunningFunctions();
    void cleanupTestCase();

private:
    App* m_app;
    Doc* m_doc;
};

void TestFunctionSelectionFix::initTestCase()
{
    m_app = new App();
    m_doc = m_app->doc();
    
    // Create some test functions
    Scene* scene1 = new Scene(m_doc);
    scene1->setName("Test Scene 1");
    m_doc->addFunction(scene1);
    
    Scene* scene2 = new Scene(m_doc);
    scene2->setName("Test Scene 2");
    m_doc->addFunction(scene2);
    
    // Start one function to test "Running Functions" filter
    scene1->start(m_doc->masterTimer(), FunctionParent::master());
}

void TestFunctionSelectionFix::testFunctionSelectionRunningFunctions()
{
    // Create FunctionSelection dialog
    FunctionSelection fs(m_app, m_doc);
    
    // Test that we can switch to "Running Functions" without crashing
    // This would previously cause a segfault due to race condition
    qDebug() << "Testing 'Running Functions' selection...";
    
    // Simulate clicking the "Running Functions" radio button
    // This calls slotRunningFunctionsChecked() which now has pause/resume protection
    fs.slotRunningFunctionsChecked();
    
    qDebug() << "Successfully switched to 'Running Functions' without crash!";
    
    // Test switching back to "All Functions"
    fs.slotAllFunctionsChecked();
    
    qDebug() << "Successfully switched back to 'All Functions'!";
    
    // Test multiple rapid switches (stress test)
    for (int i = 0; i < 10; i++) {
        fs.slotRunningFunctionsChecked();
        fs.slotAllFunctionsChecked();
    }
    
    qDebug() << "Successfully completed stress test!";
}

void TestFunctionSelectionFix::cleanupTestCase()
{
    delete m_app;
}

QTEST_MAIN(TestFunctionSelectionFix)
#include "test_function_selection_fix.moc"
