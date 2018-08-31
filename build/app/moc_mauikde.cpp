/****************************************************************************
** Meta object code from reading C++ file 'mauikde.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../mauikit/src/kde/mauikde.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mauikde.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_MAUIKDE_t {
    QByteArrayData data[12];
    char stringdata0[87];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_MAUIKDE_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_MAUIKDE_t qt_meta_stringdata_MAUIKDE = {
    {
QT_MOC_LITERAL(0, 0, 7), // "MAUIKDE"
QT_MOC_LITERAL(1, 8, 8), // "services"
QT_MOC_LITERAL(2, 17, 0), // ""
QT_MOC_LITERAL(3, 18, 3), // "url"
QT_MOC_LITERAL(4, 22, 7), // "devices"
QT_MOC_LITERAL(5, 30, 12), // "sendToDevice"
QT_MOC_LITERAL(6, 43, 6), // "device"
QT_MOC_LITERAL(7, 50, 2), // "id"
QT_MOC_LITERAL(8, 53, 4), // "urls"
QT_MOC_LITERAL(9, 58, 11), // "openWithApp"
QT_MOC_LITERAL(10, 70, 4), // "exec"
QT_MOC_LITERAL(11, 75, 11) // "attachEmail"

    },
    "MAUIKDE\0services\0\0url\0devices\0"
    "sendToDevice\0device\0id\0urls\0openWithApp\0"
    "exec\0attachEmail"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_MAUIKDE[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: name, argc, parameters, tag, flags
       1,    1,   39,    2, 0x02 /* Public */,
       4,    0,   42,    2, 0x02 /* Public */,
       5,    3,   43,    2, 0x02 /* Public */,
       9,    2,   50,    2, 0x02 /* Public */,
      11,    1,   55,    2, 0x02 /* Public */,

 // methods: parameters
    QMetaType::QVariantList, QMetaType::QUrl,    3,
    QMetaType::QVariantList,
    QMetaType::Bool, QMetaType::QString, QMetaType::QString, QMetaType::QStringList,    6,    7,    8,
    QMetaType::Void, QMetaType::QString, QMetaType::QStringList,   10,    8,
    QMetaType::Void, QMetaType::QStringList,    8,

       0        // eod
};

void MAUIKDE::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        MAUIKDE *_t = static_cast<MAUIKDE *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: { QVariantList _r = _t->services((*reinterpret_cast< const QUrl(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 1: { QVariantList _r = _t->devices();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 2: { bool _r = _t->sendToDevice((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2])),(*reinterpret_cast< const QStringList(*)>(_a[3])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 3: _t->openWithApp((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QStringList(*)>(_a[2]))); break;
        case 4: _t->attachEmail((*reinterpret_cast< const QStringList(*)>(_a[1]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject MAUIKDE::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_MAUIKDE.data,
      qt_meta_data_MAUIKDE,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *MAUIKDE::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MAUIKDE::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_MAUIKDE.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int MAUIKDE::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 5)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 5;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
