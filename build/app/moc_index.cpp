/****************************************************************************
** Meta object code from reading C++ file 'index.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../app/index.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'index.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Index_t {
    QByteArrayData data[20];
    char stringdata0[179];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Index_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Index_t qt_meta_stringdata_Index = {
    {
QT_MOC_LITERAL(0, 0, 5), // "Index"
QT_MOC_LITERAL(1, 6, 20), // "getCustomPathContent"
QT_MOC_LITERAL(2, 27, 0), // ""
QT_MOC_LITERAL(3, 28, 4), // "path"
QT_MOC_LITERAL(4, 33, 8), // "isCustom"
QT_MOC_LITERAL(5, 42, 5), // "isApp"
QT_MOC_LITERAL(6, 48, 8), // "openFile"
QT_MOC_LITERAL(7, 57, 14), // "getCustomPaths"
QT_MOC_LITERAL(8, 72, 12), // "saveSettings"
QT_MOC_LITERAL(9, 85, 3), // "key"
QT_MOC_LITERAL(10, 89, 5), // "value"
QT_MOC_LITERAL(11, 95, 5), // "group"
QT_MOC_LITERAL(12, 101, 12), // "loadSettings"
QT_MOC_LITERAL(13, 114, 12), // "defaultValue"
QT_MOC_LITERAL(14, 127, 10), // "getDirInfo"
QT_MOC_LITERAL(15, 138, 4), // "type"
QT_MOC_LITERAL(16, 143, 11), // "getFileInfo"
QT_MOC_LITERAL(17, 155, 14), // "runApplication"
QT_MOC_LITERAL(18, 170, 4), // "exec"
QT_MOC_LITERAL(19, 175, 3) // "url"

    },
    "Index\0getCustomPathContent\0\0path\0"
    "isCustom\0isApp\0openFile\0getCustomPaths\0"
    "saveSettings\0key\0value\0group\0loadSettings\0"
    "defaultValue\0getDirInfo\0type\0getFileInfo\0"
    "runApplication\0exec\0url"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Index[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      10,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   64,    2, 0x02 /* Public */,
       4,    1,   67,    2, 0x02 /* Public */,
       5,    1,   70,    2, 0x02 /* Public */,
       6,    1,   73,    2, 0x02 /* Public */,
       7,    0,   76,    2, 0x02 /* Public */,
       8,    3,   77,    2, 0x02 /* Public */,
      12,    3,   84,    2, 0x02 /* Public */,
      14,    2,   91,    2, 0x02 /* Public */,
      16,    1,   96,    2, 0x02 /* Public */,
      17,    2,   99,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::QVariantList, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::Bool, QMetaType::QString,    3,
    QMetaType::QVariantList,
    QMetaType::Void, QMetaType::QString, QMetaType::QVariant, QMetaType::QString,    9,   10,   11,
    QMetaType::QVariant, QMetaType::QString, QMetaType::QString, QMetaType::QVariant,    9,   11,   13,
    QMetaType::QVariantMap, QMetaType::QString, QMetaType::QString,    3,   15,
    QMetaType::QVariantMap, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::QString, QMetaType::QString,   18,   19,

       0        // eod
};

void Index::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Index *_t = static_cast<Index *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { QVariantList _r = _t->getCustomPathContent((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 1: { bool _r = _t->isCustom((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 2: { bool _r = _t->isApp((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 3: { bool _r = _t->openFile((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 4: { QVariantList _r = _t->getCustomPaths();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 5: _t->saveSettings((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QVariant(*)>(_a[2])),(*reinterpret_cast< const QString(*)>(_a[3]))); break;
        case 6: { QVariant _r = _t->loadSettings((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])),(*reinterpret_cast< const QVariant(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< QVariant*>(_a[0]) = std::move(_r); }  break;
        case 7: { QVariantMap _r = _t->getDirInfo((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 8: { QVariantMap _r = _t->getFileInfo((*reinterpret_cast< const QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantMap*>(_a[0]) = std::move(_r); }  break;
        case 9: _t->runApplication((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject Index::staticMetaObject = {
    { &FM::staticMetaObject, qt_meta_stringdata_Index.data,
      qt_meta_data_Index,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *Index::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Index::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Index.stringdata0))
        return static_cast<void*>(this);
    return FM::qt_metacast(_clname);
}

int Index::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = FM::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 10)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 10;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
