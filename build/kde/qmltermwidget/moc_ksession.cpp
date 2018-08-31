/****************************************************************************
** Meta object code from reading C++ file 'ksession.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../kde/qmltermwidget/src/ksession.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ksession.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_KSession_t {
    QByteArrayData data[56];
    char stringdata0[626];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_KSession_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_KSession_t qt_meta_stringdata_KSession = {
    {
QT_MOC_LITERAL(0, 0, 8), // "KSession"
QT_MOC_LITERAL(1, 9, 7), // "started"
QT_MOC_LITERAL(2, 17, 0), // ""
QT_MOC_LITERAL(3, 18, 8), // "finished"
QT_MOC_LITERAL(4, 27, 13), // "copyAvailable"
QT_MOC_LITERAL(5, 41, 12), // "termGetFocus"
QT_MOC_LITERAL(6, 54, 13), // "termLostFocus"
QT_MOC_LITERAL(7, 68, 14), // "termKeyPressed"
QT_MOC_LITERAL(8, 83, 10), // "QKeyEvent*"
QT_MOC_LITERAL(9, 94, 18), // "changedKeyBindings"
QT_MOC_LITERAL(10, 113, 2), // "kb"
QT_MOC_LITERAL(11, 116, 12), // "titleChanged"
QT_MOC_LITERAL(12, 129, 18), // "historySizeChanged"
QT_MOC_LITERAL(13, 148, 30), // "initialWorkingDirectoryChanged"
QT_MOC_LITERAL(14, 179, 10), // "matchFound"
QT_MOC_LITERAL(15, 190, 11), // "startColumn"
QT_MOC_LITERAL(16, 202, 9), // "startLine"
QT_MOC_LITERAL(17, 212, 9), // "endColumn"
QT_MOC_LITERAL(18, 222, 7), // "endLine"
QT_MOC_LITERAL(19, 230, 12), // "noMatchFound"
QT_MOC_LITERAL(20, 243, 14), // "setKeyBindings"
QT_MOC_LITERAL(21, 258, 8), // "setTitle"
QT_MOC_LITERAL(22, 267, 4), // "name"
QT_MOC_LITERAL(23, 272, 17), // "startShellProgram"
QT_MOC_LITERAL(24, 290, 10), // "sendSignal"
QT_MOC_LITERAL(25, 301, 6), // "signal"
QT_MOC_LITERAL(26, 308, 15), // "setShellProgram"
QT_MOC_LITERAL(27, 324, 8), // "progname"
QT_MOC_LITERAL(28, 333, 7), // "setArgs"
QT_MOC_LITERAL(29, 341, 4), // "args"
QT_MOC_LITERAL(30, 346, 11), // "getShellPID"
QT_MOC_LITERAL(31, 358, 9), // "changeDir"
QT_MOC_LITERAL(32, 368, 3), // "dir"
QT_MOC_LITERAL(33, 372, 8), // "sendText"
QT_MOC_LITERAL(34, 381, 4), // "text"
QT_MOC_LITERAL(35, 386, 7), // "sendKey"
QT_MOC_LITERAL(36, 394, 3), // "rep"
QT_MOC_LITERAL(37, 398, 3), // "key"
QT_MOC_LITERAL(38, 402, 3), // "mod"
QT_MOC_LITERAL(39, 406, 11), // "clearScreen"
QT_MOC_LITERAL(40, 418, 6), // "search"
QT_MOC_LITERAL(41, 425, 6), // "regexp"
QT_MOC_LITERAL(42, 432, 8), // "forwards"
QT_MOC_LITERAL(43, 441, 15), // "sessionFinished"
QT_MOC_LITERAL(44, 457, 16), // "selectionChanged"
QT_MOC_LITERAL(45, 474, 12), // "textSelected"
QT_MOC_LITERAL(46, 487, 13), // "createSession"
QT_MOC_LITERAL(47, 501, 8), // "Session*"
QT_MOC_LITERAL(48, 510, 8), // "kbScheme"
QT_MOC_LITERAL(49, 519, 23), // "initialWorkingDirectory"
QT_MOC_LITERAL(50, 543, 5), // "title"
QT_MOC_LITERAL(51, 549, 12), // "shellProgram"
QT_MOC_LITERAL(52, 562, 16), // "shellProgramArgs"
QT_MOC_LITERAL(53, 579, 7), // "history"
QT_MOC_LITERAL(54, 587, 16), // "hasActiveProcess"
QT_MOC_LITERAL(55, 604, 21) // "foregroundProcessName"

    },
    "KSession\0started\0\0finished\0copyAvailable\0"
    "termGetFocus\0termLostFocus\0termKeyPressed\0"
    "QKeyEvent*\0changedKeyBindings\0kb\0"
    "titleChanged\0historySizeChanged\0"
    "initialWorkingDirectoryChanged\0"
    "matchFound\0startColumn\0startLine\0"
    "endColumn\0endLine\0noMatchFound\0"
    "setKeyBindings\0setTitle\0name\0"
    "startShellProgram\0sendSignal\0signal\0"
    "setShellProgram\0progname\0setArgs\0args\0"
    "getShellPID\0changeDir\0dir\0sendText\0"
    "text\0sendKey\0rep\0key\0mod\0clearScreen\0"
    "search\0regexp\0forwards\0sessionFinished\0"
    "selectionChanged\0textSelected\0"
    "createSession\0Session*\0kbScheme\0"
    "initialWorkingDirectory\0title\0"
    "shellProgram\0shellProgramArgs\0history\0"
    "hasActiveProcess\0foregroundProcessName"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_KSession[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      30,   14, // methods
       8,  252, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
      12,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,  164,    2, 0x06 /* Public */,
       3,    0,  165,    2, 0x06 /* Public */,
       4,    1,  166,    2, 0x06 /* Public */,
       5,    0,  169,    2, 0x06 /* Public */,
       6,    0,  170,    2, 0x06 /* Public */,
       7,    1,  171,    2, 0x06 /* Public */,
       9,    1,  174,    2, 0x06 /* Public */,
      11,    0,  177,    2, 0x06 /* Public */,
      12,    0,  178,    2, 0x06 /* Public */,
      13,    0,  179,    2, 0x06 /* Public */,
      14,    4,  180,    2, 0x06 /* Public */,
      19,    0,  189,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      20,    1,  190,    2, 0x0a /* Public */,
      21,    1,  193,    2, 0x0a /* Public */,
      23,    0,  196,    2, 0x0a /* Public */,
      24,    1,  197,    2, 0x0a /* Public */,
      26,    1,  200,    2, 0x0a /* Public */,
      28,    1,  203,    2, 0x0a /* Public */,
      30,    0,  206,    2, 0x0a /* Public */,
      31,    1,  207,    2, 0x0a /* Public */,
      33,    1,  210,    2, 0x0a /* Public */,
      35,    3,  213,    2, 0x0a /* Public */,
      39,    0,  220,    2, 0x0a /* Public */,
      40,    4,  221,    2, 0x0a /* Public */,
      40,    3,  230,    2, 0x2a /* Public | MethodCloned */,
      40,    2,  237,    2, 0x2a /* Public | MethodCloned */,
      40,    1,  242,    2, 0x2a /* Public | MethodCloned */,
      43,    0,  245,    2, 0x09 /* Protected */,
      44,    1,  246,    2, 0x09 /* Protected */,
      46,    1,  249,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,    2,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 8,    2,
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int, QMetaType::Int, QMetaType::Int, QMetaType::Int,   15,   16,   17,   18,
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void, QMetaType::QString,   22,
    QMetaType::Void,
    QMetaType::Bool, QMetaType::Int,   25,
    QMetaType::Void, QMetaType::QString,   27,
    QMetaType::Void, QMetaType::QStringList,   29,
    QMetaType::Int,
    QMetaType::Void, QMetaType::QString,   32,
    QMetaType::Void, QMetaType::QString,   34,
    QMetaType::Void, QMetaType::Int, QMetaType::Int, QMetaType::Int,   36,   37,   38,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString, QMetaType::Int, QMetaType::Int, QMetaType::Bool,   41,   16,   15,   42,
    QMetaType::Void, QMetaType::QString, QMetaType::Int, QMetaType::Int,   41,   16,   15,
    QMetaType::Void, QMetaType::QString, QMetaType::Int,   41,   16,
    QMetaType::Void, QMetaType::QString,   41,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,   45,
    0x80000000 | 47, QMetaType::QString,   22,

 // properties: name, type, flags
      48, QMetaType::QString, 0x00495003,
      49, QMetaType::QString, 0x00495103,
      50, QMetaType::QString, 0x00495103,
      51, QMetaType::QString, 0x00095102,
      52, QMetaType::QStringList, 0x00095002,
      53, QMetaType::QString, 0x00095001,
      54, QMetaType::Bool, 0x00095001,
      55, QMetaType::QString, 0x00095001,

 // properties: notify_signal_id
       6,
       9,
       7,
       0,
       0,
       0,
       0,
       0,

       0        // eod
};

void KSession::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        KSession *_t = static_cast<KSession *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->started(); break;
        case 1: _t->finished(); break;
        case 2: _t->copyAvailable((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 3: _t->termGetFocus(); break;
        case 4: _t->termLostFocus(); break;
        case 5: _t->termKeyPressed((*reinterpret_cast< QKeyEvent*(*)>(_a[1]))); break;
        case 6: _t->changedKeyBindings((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 7: _t->titleChanged(); break;
        case 8: _t->historySizeChanged(); break;
        case 9: _t->initialWorkingDirectoryChanged(); break;
        case 10: _t->matchFound((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< int(*)>(_a[4]))); break;
        case 11: _t->noMatchFound(); break;
        case 12: _t->setKeyBindings((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 13: _t->setTitle((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 14: _t->startShellProgram(); break;
        case 15: { bool _r = _t->sendSignal((*reinterpret_cast< int(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 16: _t->setShellProgram((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 17: _t->setArgs((*reinterpret_cast< const QStringList(*)>(_a[1]))); break;
        case 18: { int _r = _t->getShellPID();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 19: _t->changeDir((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 20: _t->sendText((*reinterpret_cast< QString(*)>(_a[1]))); break;
        case 21: _t->sendKey((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 22: _t->clearScreen(); break;
        case 23: _t->search((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< bool(*)>(_a[4]))); break;
        case 24: _t->search((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3]))); break;
        case 25: _t->search((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< int(*)>(_a[2]))); break;
        case 26: _t->search((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 27: _t->sessionFinished(); break;
        case 28: _t->selectionChanged((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 29: { Session* _r = _t->createSession((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< Session**>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::started)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::finished)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (KSession::*)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::copyAvailable)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::termGetFocus)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::termLostFocus)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (KSession::*)(QKeyEvent * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::termKeyPressed)) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (KSession::*)(QString );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::changedKeyBindings)) {
                *result = 6;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::titleChanged)) {
                *result = 7;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::historySizeChanged)) {
                *result = 8;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::initialWorkingDirectoryChanged)) {
                *result = 9;
                return;
            }
        }
        {
            using _t = void (KSession::*)(int , int , int , int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::matchFound)) {
                *result = 10;
                return;
            }
        }
        {
            using _t = void (KSession::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&KSession::noMatchFound)) {
                *result = 11;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        KSession *_t = static_cast<KSession *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->getKeyBindings(); break;
        case 1: *reinterpret_cast< QString*>(_v) = _t->getInitialWorkingDirectory(); break;
        case 2: *reinterpret_cast< QString*>(_v) = _t->getTitle(); break;
        case 5: *reinterpret_cast< QString*>(_v) = _t->getHistory(); break;
        case 6: *reinterpret_cast< bool*>(_v) = _t->hasActiveProcess(); break;
        case 7: *reinterpret_cast< QString*>(_v) = _t->foregroundProcessName(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        KSession *_t = static_cast<KSession *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setKeyBindings(*reinterpret_cast< QString*>(_v)); break;
        case 1: _t->setInitialWorkingDirectory(*reinterpret_cast< QString*>(_v)); break;
        case 2: _t->setTitle(*reinterpret_cast< QString*>(_v)); break;
        case 3: _t->setShellProgram(*reinterpret_cast< QString*>(_v)); break;
        case 4: _t->setArgs(*reinterpret_cast< QStringList*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject KSession::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_KSession.data,
      qt_meta_data_KSession,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *KSession::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *KSession::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_KSession.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int KSession::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 30)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 30;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 30)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 30;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 8;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 8;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void KSession::started()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void KSession::finished()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void KSession::copyAvailable(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void KSession::termGetFocus()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}

// SIGNAL 4
void KSession::termLostFocus()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void KSession::termKeyPressed(QKeyEvent * _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void KSession::changedKeyBindings(QString _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}

// SIGNAL 7
void KSession::titleChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 7, nullptr);
}

// SIGNAL 8
void KSession::historySizeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 8, nullptr);
}

// SIGNAL 9
void KSession::initialWorkingDirectoryChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 9, nullptr);
}

// SIGNAL 10
void KSession::matchFound(int _t1, int _t2, int _t3, int _t4)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)), const_cast<void*>(reinterpret_cast<const void*>(&_t2)), const_cast<void*>(reinterpret_cast<const void*>(&_t3)), const_cast<void*>(reinterpret_cast<const void*>(&_t4)) };
    QMetaObject::activate(this, &staticMetaObject, 10, _a);
}

// SIGNAL 11
void KSession::noMatchFound()
{
    QMetaObject::activate(this, &staticMetaObject, 11, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
