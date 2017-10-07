--ネクロイド・シンクロ
function c26194151.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c26194151.target)
	e1:SetOperation(c26194151.activate)
	c:RegisterEffect(e1)
end
c26194151.synchro=nil
c26194151.tuner=nil
function c26194151.filter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xa3) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c26194151.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp,c)
end
function c26194151.rescon(sg,e,tp,mg)
	local sc=c26194151.synchro
	sg:AddCard(c26194151.tuner)
	local res=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
		and sg:CheckWithSumEqual(Card.GetLevel,sc:GetLevel(),sg:GetCount(),sg:GetCount())
	sg:RemoveCard(c26194151.tuner)
	return res
end
function c26194151.filter2(c,tp,sc)
	local rg=Duel.GetMatchingGroup(c26194151.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if not c:IsType(TYPE_TUNER) or not c:IsAbleToRemove() or not aux.SpElimFilter(c,true) then return false end
	c26194151.synchro=sc
	c26194151.tuner=c
	local res=aux.SelectUnselectGroup(rg,e,tp,nil,2,c26194151.rescon,0)
	c26194151.synchro=nil
	c26194151.tuner=nil
	return res
end
function c26194151.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function c26194151.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26194151.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c26194151.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c26194151.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local sc=g1:GetFirst()
	if sc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c26194151.filter2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp,sc)
		local tuner=g2:GetFirst()
		local rg=Duel.GetMatchingGroup(c26194151.filter3,tp,LOCATION_MZONE+LOCATION_GRAVE,0,tuner)
		c26194151.synchro=sc
		c26194151.tuner=tuner
		local sg=aux.SelectUnselectGroup(mg,e,tp,nil,2,c26194151.rescon,1,tp,HINTMSG_REMOVE,c26194151.rescon)
		c26194151.synchro=nil
		c26194151.tuner=nil
		sg:AddCard(tuner)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummonStep(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		sc:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
