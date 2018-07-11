#ifndef QMAKE_EXAMPLE
#define QMAKE_EXAMPLE

#include <QObject>

class QMakeExample: public QObject {
	Q_OBJECT
public:
	explicit QMakeExample(QObject* parent = 0)
		: QObject(parent) { }
	void hello();
};


#endif

