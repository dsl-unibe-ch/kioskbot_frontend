<script lang="ts">
	const { sessionID } = $props();
</script>

<h1 class="mb-9 scroll-m-20 text-center text-4xl font-extrabold tracking-tight lg:text-5xl">
	Kioskbot der Universität Bern
</h1>
<div class="flex items-center justify-center gap-4 p-4">
	{#if sessionID}
		<p>Session ID: {sessionID}</p>
	{:else}
		<p>
			Der Chatbot ist momentan nur im Uni-Netz der Universität Bern erreichbar. Bitte loggen sie
			sich via VPN ins Uni-Netz ein und laden Sie die Seite erneut.
		</p>
	{/if}
</div>
