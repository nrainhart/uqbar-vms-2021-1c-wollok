Class {
	#name : #WollokTrue,
	#superclass : #WollokBoolean,
	#category : #'WollokVM-Interpreter'
}

{ #category : #'logical operations' }
WollokTrue >> & unBooleano [

	^ unBooleano
]

{ #category : #'logical operations' }
WollokTrue >> isWollokFalse [

	^ false
]

{ #category : #'logical operations' }
WollokTrue >> isWollokTrue [

	^ true
]

{ #category : #'native methods' }
WollokTrue >> | aWollokBoolean [

	^ self
]
