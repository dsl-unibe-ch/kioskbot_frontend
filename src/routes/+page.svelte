<script lang="ts">
	import { Button, buttonVariants } from '$lib/components/ui/button/index.js';
	import { Textarea } from '$lib/components/ui/textarea/index.js';
	import { Skeleton } from '$lib/components/ui/skeleton/index.js';
	import * as Sheet from '$lib/components/ui/sheet/index.js';
	import { TextareaAutosize } from 'runed';
	import { PUBLIC_API } from '$env/static/public';
	import Send from '@lucide/svelte/icons/send';
	import LoaderCircle from '@lucide/svelte/icons/loader-circle';
	import * as AlertDialog from '$lib/components/ui/alert-dialog/index.js';
	import { onMount } from 'svelte';
	import { marked } from 'marked';
	let { data } = $props();
	let { sessionID } = data;
	let messages: {
		text: string;
		sources?: {
			document_location: string;
			page_content: string;
			document_url: string;
			category: string;
			title: string;
			gathered_on: string;
			modified: string;
			score: number;
		}[];
		issuer: string;
	}[] = $state([]);
	let qVal = $state('');

	let locked = $state(false);

	onMount(async () => {
		const qEl = document.querySelector('textarea');
		if (!qEl) return;
		new TextareaAutosize({
			element: () => qEl,
			input: () => qVal
		});
	});

	const submitFeedback = async (rating: number, comments: string) => {
		const response = await fetch(`${PUBLIC_API}/send_feedback`, {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json'
			},
			body: JSON.stringify({
				session_id: sessionID,
				rating,
				comments
			})
		});
		if (response.ok) {
			console.log('Feedback sent successfully');
		} else {
			console.error('Failed to send feedback');
		}
	};

	let helpful = $state(1);
	let feedbackMessages: string[] = $state([]);
</script>

<AlertDialog.Root open>
	<AlertDialog.Content class="w-full! max-w-full! sm:max-w-2xl!">
		<AlertDialog.Header>
			<AlertDialog.Title>Nutzungsbedingungen und Haftungsausschluss</AlertDialog.Title>
			<AlertDialog.Description>
				Bitte lesen und akzeptieren Sie die folgenden Bedingungen, bevor Sie diese Anwendung nutzen:
			</AlertDialog.Description>
		</AlertDialog.Header>
		<ul class="max-h-60 list-disc space-y-2 overflow-y-auto pl-6">
			<li>
				Diese Anwendung dient als Unterstützung bei der Suche nach Informationen im Zusammenhang mit
				den Aktivitäten der Abteilung für Qualitätssicherung und -entwicklung der Universität Bern.
			</li>
			<li>Diese Anwendung richtet sich an die Angehörigen der Universität Bern.</li>
			<li>
				Der Chatbot ist für Informationen allgemeiner Art und nicht für persönliche oder
				vertrauliche Anfragen vorgesehen. In solchen Fällen wenden Sie sich bitte direkt an die
				entsprechende Abteilung.
			</li>
			<li>
				Der Chatbot basiert auf einem Dienst von Microsoft Azure OpenAI (vgl. auch Data, privacy,
				and security for Azure OpenAI Service). Bei der Nutzung des Chatbots werden folgende Angaben
				zwecks Qualitätssicherung und Weiterentwicklung/Verbesserung der Anwendung aufgezeichnet:
				anonyme User-ID; jeweilige Organisationseinheit der Universität (Benutzergruppe); Inhalt der
				Benutzeranfrage; Antwort des Chatbots, Feedback (Bewertungen und Kommentare) an den Chatbot.
			</li>
			<li>
				Durch die Nutzung dieser Anwendung willigen Sie in die oben genannte Bearbeitung Ihrer
				Nutzerdaten ein.
			</li>
			<li>
				Die von dieser Anwendung bereitgestellten Informationen dienen ausschliesslich
				Informationszwecken. Die Universität Bern übernimmt keine Gewähr für die Richtigkeit,
				Vollständigkeit oder Aktualität der bereitgestellten Informationen.
			</li>
			<li>
				Antworten werden automatisiert von einem KI-System generiert und nicht von menschlichen
				Mitarbeitenden überprüft. Wenn Ihre Anfrage komplex oder sensibel ist und/oder menschliche
				Unterstützung erfordert, wenden Sie sich bitte direkt an die zuständige Stelle.
			</li>
			<li>
				Die vom Chatbot bereitgestellten Informationen stellen keine rechtliche Beratung dar. Für
				verbindliche Auskünfte wenden Sie sich bitte an die zuständigen Abteilungen und offiziellen
				Kanäle der Universität.
			</li>
			<li>
				Die Universität Bern haftet nicht für Folgen, die sich aus der Nutzung der vom Chatbot
				bereitgestellten Informationen ergeben.
			</li>
			<li>
				Jeglicher Missbrauch des Dienstes, insbesondere im Zusammenhang mit illegalen Aktivitäten
				oder der Verbreitung schädlicher Inhalte, ist untersagt. Es gelten die Weisungen der
				Universitätsleitung zur Benutzung der IT-Ressourcen an der Universität Bern. Abrufbar unter:
				ul_ws_benutzung_it_ressourcen_ger.pdf
			</li>
			<li>
				Die Universität Bern behält sich das Recht vor, diese Nutzungsbedingungen jederzeit zu
				aktualisieren. Änderungen werden auf dieser Seite veröffentlicht.
			</li>
		</ul>
		<p class="mt-4">
			Indem Sie auf „Akzeptieren“ klicken, bestätigen Sie, dass Sie diese Bedingungen gelesen,
			verstanden und akzeptiert haben.
		</p>

		<AlertDialog.Footer>
			<AlertDialog.Cancel>Akzeptieren</AlertDialog.Cancel>
		</AlertDialog.Footer>
	</AlertDialog.Content>
</AlertDialog.Root>

<h1 class="mb-9 scroll-m-20 text-center text-4xl font-extrabold tracking-tight lg:text-5xl">
	Kioskbot der Universität Bern
</h1>
<div class="flex flex-col items-center justify-center gap-4 p-4">
	{#if sessionID}
		{#if messages.length === 0}
			<p class="text-gray-500">
				Keine Nachrichten vorhanden. Bitte senden Sie eine Nachricht an den Kioskbot.
			</p>
		{:else}
			{#each messages as message, index}
				<div
					class={[
						'w-full max-w-2xl rounded-lg border border-gray-200  p-4 shadow-md',
						message.issuer === 'bot' ? 'bg-secondary' : 'bg-white'
					]}
				>
					<p class="mb-2 text-gray-700">{message.text}</p>
					{#if message.sources && message.sources.length > 0}
						<Sheet.Root>
							<Sheet.Trigger class={buttonVariants({ variant: 'default' })}>Quellen</Sheet.Trigger>
							<Sheet.Content class="w-full! sm:w-[540px]!">
								<Sheet.Header>
									<Sheet.Title>verwendete Quellen</Sheet.Title>
								</Sheet.Header>
								<div class=" h-full overflow-y-auto">
									{#each message.sources as source}
										<div class="mb-2">
											<dl class="pl-2">
												<dt class="text-sm font-semibold">Titel</dt>
												<dd class="mb-1">
													{#if source.document_url.startsWith('http')}
														<a href={source.document_url} target="_blank" rel="noopener noreferrer">
															{source.title}
														</a>
													{:else}
														{source.title}
													{/if}
												</dd>
												<dt class="text-xs font-semibold text-gray-500">Kategorie</dt>
												<dd class="mb-1 text-xs">{source.category}</dd>
												<dt class="text-xs font-semibold text-gray-500">Ort</dt>
												<dd class="mb-1">{source.document_location}</dd>
												<dt class="text-xs font-semibold text-gray-500">Datum</dt>
												<dd class="mb-1 text-xs">{source.gathered_on}</dd>
												<dt class="text-xs font-semibold text-gray-500">Score</dt>
												<dd class="mb-1 text-xs">{source.score.toFixed(2)}</dd>
												<dt class="text-xs font-semibold text-gray-500">Letzte Änderung</dt>
												<dd class="mb-1 text-xs">{source.modified}</dd>
												<dt class="text-xs font-semibold text-gray-500">Inhalt</dt>
												<dd class="prose mb-1 text-xs">
													{@html marked.parse(source.page_content)}
												</dd>
											</dl>
										</div>
									{/each}
								</div>
							</Sheet.Content>
						</Sheet.Root>
					{/if}
					{#if message.issuer === 'bot'}
						<p class="semibold mb-1">War die Antwort hilfreich?</p>
						<form
							onsubmit={(e) => {
								e.preventDefault();
								//validate if required fields are filled
								if (helpful === 0 && !feedbackMessages[index].trim()) {
									alert(
										'Bitte geben Sie einen Kommentar ein, wenn die Antwort nicht hilfreich war.'
									);
									return;
								}
								//submit feedback
								submitFeedback(helpful, feedbackMessages[index]);
							}}
						>
							<div class="mb-2 flex space-x-2">
								<Button
									variant="outline"
									size="sm"
									onclick={(e) => {
										helpful = 1;
										e.preventDefault();
										const target = e.target as HTMLTextAreaElement;
										target.form?.requestSubmit();
									}}
								>
									Ja
								</Button>
								<Button
									variant="outline"
									size="sm"
									onclick={() => {
										helpful = 0;
										document.getElementById(`feedback-comments_${index}`)?.focus();
									}}
								>
									Nein
								</Button>
							</div>
							<p class="mb-1">Kommentare</p>
							<Textarea
								placeholder="Feedback eingeben..."
								bind:value={feedbackMessages[index]}
								onkeydown={(e) => {
									if (e.key === 'Enter' && !e.shiftKey) {
										e.preventDefault();
										const target = e.target as HTMLTextAreaElement;
										target.form?.requestSubmit();
									}
								}}
								required={helpful === 0}
								id="feedback-comments_{index}"
								class="mb-2"
							/>
							<Button type="submit" size="sm">Absenden</Button>
						</form>
					{/if}
				</div>
			{/each}
			{#if locked}
				<div class="w-full max-w-2xl rounded-lg border border-gray-200 bg-white p-4 shadow-md">
					<Skeleton class="mb-2 h-4 w-[100px] rounded-full" />
					<Skeleton class="mb-2 h-4 w-[200px] rounded-full" />
					<Skeleton class="mb-2 h-4 w-[200px] rounded-full" />
				</div>
			{/if}
		{/if}
		<form
			onsubmit={async (e) => {
				e.preventDefault();
				if (!qVal.trim()) return; // Ignore empty messages
				locked = true;
				messages = [
					...messages,
					{
						text: qVal,
						issuer: 'user'
					}
				];
				// Call the RAG agent API
				const response = await fetch(`${PUBLIC_API}/rag-agent`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json'
					},
					body: JSON.stringify({ text: qVal, session_id: sessionID })
				});
				const answer = await response.json();
				messages = [
					...messages,
					{
						text: answer.output,
						sources: answer.sources,
						issuer: 'bot'
					}
				];
				qVal = '';
				locked = false;
			}}
			class="flex w-full max-w-2xl space-x-2"
		>
			<Textarea
				placeholder="Nachricht eingeben..."
				bind:value={qVal}
				onkeydown={(e) => {
					if (e.key === 'Enter' && !e.shiftKey) {
						e.preventDefault();
						const target = e.target as HTMLTextAreaElement;
						target.form?.requestSubmit();
					}
				}}
				data-sveltekit-keepfocus
			/>
			<Button type="submit" size="icon" class="hover:cursor-pointer" disabled={locked}>
				{#if locked}
					<LoaderCircle class="animate-spin" />
				{:else}
					<Send />
				{/if}
			</Button>
		</form>
	{:else}
		<p>
			Der Chatbot ist momentan nur im Uni-Netz der Universität Bern erreichbar. Bitte loggen sie
			sich via VPN ins Uni-Netz ein und laden Sie die Seite erneut.
		</p>
	{/if}
</div>
