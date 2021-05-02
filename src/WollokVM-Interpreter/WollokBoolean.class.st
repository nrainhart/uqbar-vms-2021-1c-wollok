Class {
	#name : #WollokBoolean,
	#superclass : #Object,
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokBoolean >> isWollokTrue [
	^self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WollokBoolean >> literalValue [
	^ self isWollokTrue
]

{ #category : #'as yet unclassified' }
WollokBoolean >> wollokClassName [
	^ 'wollok.lang.Boolean'
]
