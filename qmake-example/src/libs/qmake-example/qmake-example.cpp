#include <QDebug>

#include "config.h"

#include "qmake-example.h"

void QMakeExample::hello()
{
	qDebug() << "Hello " << VERSION;
}

