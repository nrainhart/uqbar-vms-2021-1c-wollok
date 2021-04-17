Class {
	#name : #WollokGlobalScope,
	#superclass : #Object,
	#instVars : [
		'globalVariables'
	],
	#category : #'WollokVM-Interpreter'
}

{ #category : #'as yet unclassified' }
WollokGlobalScope >> declareVariable: variableName withValue: variableValue [ 
	globalVariables at: variableName put: variableValue
]

{ #category : #'as yet unclassified' }
WollokGlobalScope >> initialize [ 
	globalVariables := Dictionary new.
]

{ #category : #'as yet unclassified' }
WollokGlobalScope >> variableValue: variableName [ 
	^ globalVariables at: variableName.
]
