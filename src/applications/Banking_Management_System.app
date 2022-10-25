<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <brand>
        <headerColor>#78B6EE</headerColor>
        <logo>BankImg</logo>
        <logoVersion>1</logoVersion>
        <shouldOverrideOrgTheme>true</shouldOverrideOrgTheme>
    </brand>
    <description>A banking application with real life uses</description>
    <formFactors>Small</formFactors>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <isNavTabPersistenceDisabled>false</isNavTabPersistenceDisabled>
    <label>Banking Management System</label>
    <navType>Standard</navType>
    <profileActionOverrides>
        <actionName>Tab</actionName>
        <content>Home_Page_Default</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Admin</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>Tab</actionName>
        <content>Home_Page_Default</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Standard</profile>
    </profileActionOverrides>
    <profileActionOverrides>
        <actionName>Tab</actionName>
        <content>Home_Page_Default</content>
        <formFactor>Large</formFactor>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
        <type>Flexipage</type>
        <profile>Custom Profile(Read_Create_only)</profile>
    </profileActionOverrides>
    <tabs>standard-home</tabs>
    <tabs>standard-Feed</tabs>
    <tabs>standard-Account</tabs>
    <tabs>Transaction_Entry__c</tabs>
    <tabs>standard-Case</tabs>
    <tabs>standard-report</tabs>
    <tabs>standard-Dashboard</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>Banking_Management_System_UtilityBar</utilityBar>
</CustomApplication>
