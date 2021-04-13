Class {
	#name : #WollokStringLiteralNode,
	#superclass : #WollokAbstractNodeNode,
	#instVars : [
		'value'
	],
	#category : #'Wollok-Parser'
}

{ #category : #generated }
WollokStringLiteralNode >> acceptVisitor: anAbstractNodeVisitor [
	^ anAbstractNodeVisitor visitStringLiteral: self
]

{ #category : #'as yet unclassified' }
WollokStringLiteralNode >> stringValue [
	^ self value value allButFirst allButLast
]

{ #category : #generated }
WollokStringLiteralNode >> tokenVariables [
	^ #(#value)
]

{ #category : #generated }
WollokStringLiteralNode >> value [
	^ value
]

{ #category : #generated }
WollokStringLiteralNode >> value: aSmaCCToken [
	value := aSmaCCToken
]
