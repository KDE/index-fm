#pragma once

#include <QQuickPaintedItem>

class PathArrowBackground : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color MEMBER m_color NOTIFY colorChanged)
    Q_PROPERTY(int arrowWidth MEMBER m_arrowWidth NOTIFY arrowWidthChanged)

public:
    PathArrowBackground(QQuickItem *parent = nullptr);

protected:
    void paint(QPainter *painter) override;

private:
    QColor m_color;
    int m_arrowWidth;

Q_SIGNALS:
    void colorChanged();
    void arrowWidthChanged();
};
